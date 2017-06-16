//
//  CollectionUpdater.swift
//  Pods
//
//  Created by Guihal Gwenn on 05/04/17.
//
//

import Foundation
import Dwifft

final public class CollectionUpdater {
    
    var result:UpdateCollectionResult?
    
    unowned let collectionDatas:CollectionDatas
    
    init(collectionDatas:CollectionDatas) {
        self.collectionDatas = collectionDatas
    }
    
    public func reloadData() {
        let oldSections = collectionDatas.sections // store old model
        collectionDatas.reloadData() // compute new model
        
        do {
            try verifyUID(sections: oldSections)
            try verifyUID(sections: collectionDatas.sections)
            
            let old = mapToSectionedValues(oldSections)
            let new = mapToSectionedValues(collectionDatas.sections)
            
            Dwifft.diff(lhs: old, rhs: new).forEach {
                switch $0 {
                case let .delete(section, item, _):
                    result?.deletedIndexPaths.append( IndexPath(item: item, section: section ) )
                    result?.deletedCellDescriptors.append( oldSections[section].cells[item] )
                case let .insert(section, item, _):
                    result?.insertedIndexPaths.append( IndexPath(item: item, section: section ) )
                    result?.deletedCellDescriptors.append( collectionDatas.sections[section].cells[item] )
                case let .sectionDelete(section, _):
                    result?.deletedSectionsIndexSet.insert(section)
                    result?.deletedSectionDescriptors.append( oldSections[section] )
                case let .sectionInsert(section, _):
                    result?.insertedSectionsIndexSet.insert(section)
                    result?.insertedSectionDescriptors.append( collectionDatas.sections[section] )
                }
            }
            
        } catch UIDError.sectionsWithoutUIDError(let sections) {
            let sectionsInError = sections.reduce("") { result, section in
                return result + "- section:\(section.0), description:\(section.1)\n"
            }
            assertionFailure("No UID given for sections:\n \(sectionsInError)")
        } catch UIDError.itemsWithoutUIDError(let items) {
            let itemsInError = items.reduce("") { result, item in
                return result + "- section: \(item.0), item:\(item.1), description:\(item.2)\n"
            }
            assertionFailure("No UID given for items:\n \(itemsInError)")
        } catch {}
    }
    
    private func mapToSectionedValues(_ sections:[CollectionSectionDescribable]) -> SectionedValues<String, String> {
        return SectionedValues( sections.map{ section -> (String, [String]) in
            let cellUids = section.cells.map{ return section._uid! + "/" + $0._uid! }
            return (section._uid!, cellUids)
        })
    }
    
    private enum UIDError : Error {
        case sectionsWithoutUIDError(sections:[(Int,CollectionSectionDescribable)])
        case itemsWithoutUIDError(items:[(Int,Int,CollectionCellDescribable)])
    }
    
    private func verifyUID(sections:[CollectionSectionDescribable]) throws {
        var sectionsWithoutUID = [(Int,CollectionSectionDescribable)]()
        var itemsWithoutUID = [(Int,Int,CollectionCellDescribable)]()
        
        for (sectionIndex, section) in sections.enumerated() {
            guard let _ = section._uid else {
                sectionsWithoutUID.append( (sectionIndex,section) )
                return
            }
            
            let cells = section.cells.enumerated().filter {
                return $0.element._uid == nil
            }.map {
                return (sectionIndex, $0.offset, $0.element)
            }
            itemsWithoutUID.append(contentsOf: cells)
        }
        
        if !sectionsWithoutUID.isEmpty {
            throw UIDError.sectionsWithoutUIDError(sections: sectionsWithoutUID)
        }
        else if !itemsWithoutUID.isEmpty {
            throw UIDError.itemsWithoutUIDError(items: itemsWithoutUID)
        }
    }
    
    public func append(cells:[CollectionCellDescribable], after cell:CollectionCellDescribable) {
        if let section = collectionDatas.sections[safe: cell.indexPath.section] {
            section.cells.insert(contentsOf: cells, at: cell.indexPath.item + 1)
            collectionDatas.computeIndices()
            
            result?.insertedCellDescriptors.append(contentsOf: cells)
            result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func append(cells:[CollectionCellDescribable], before cell:CollectionCellDescribable) {
        if let section = collectionDatas.sections[safe: cell.indexPath.section] {
            section.cells.insert(contentsOf: cells, at: cell.indexPath.item)
            collectionDatas.computeIndices()
            
            result?.insertedCellDescriptors.append(contentsOf: cells)
            result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func append(cells:[CollectionCellDescribable], in section:CollectionSectionDescribable) {
        section.cells.append(contentsOf: cells)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
    }
    
    public func remove(cells:[CollectionCellDescribable]) {
        var needTocomputeIndices = false
        cells.forEach { (cellToDelete) in
            if let section = collectionDatas.sectionDescribable(for: cellToDelete) {
                if let index = section.cells.index(where: {$0 === cellToDelete} ) {
                    section.cells.remove(at: index)
                    result?.deletedIndexPaths.append( cellToDelete.indexPath )
                    result?.deletedCellDescriptors.append(cellToDelete )
                    needTocomputeIndices = true
                }
            }
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(cells:[CollectionCellDescribable]) {
        result?.reloadedIndexPaths.append(contentsOf: cells.map { $0.indexPath } )
        result?.reloadedCellDescriptors.append(contentsOf: cells)
    }
    
    public func append(sections:[CollectionSectionDescribable], after section:CollectionSectionDescribable) {
        collectionDatas.sections.insert(contentsOf: sections, at: section.index + 1)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: section.index + 1, upper: section.index + 1 + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func append(sections:[CollectionSectionDescribable], before section:CollectionSectionDescribable) {
        collectionDatas.sections.insert(contentsOf: sections, at: section.index)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: section.index, upper: section.index + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func append(sections:[CollectionSectionDescribable]) {
        let oldSectionsCount = collectionDatas.sections.count
        collectionDatas.sections.append(contentsOf: sections)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: oldSectionsCount, upper: oldSectionsCount + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func remove(sections:[CollectionSectionDescribable]) {
        var needTocomputeIndices = false
        sections.forEach { (sectionToDelete) in
            if let index = collectionDatas.sections.index(where: {$0 === sectionToDelete} ) {
                collectionDatas.sections.remove(at: index)
                result?.deletedSectionsIndexSet.insert(index)
                result?.deletedSectionDescriptors.append(sectionToDelete)
                needTocomputeIndices = true
            }
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(sections:[CollectionSectionDescribable]) {
        sections.forEach { (sectionToReload) in
            if let index = collectionDatas.sections.index(where: {$0 === sectionToReload} ) {
                result?.reloadedSectionsIndexSet.insert(index)
                result?.reloadedSectionDescriptors.append(sectionToReload)
            }
        }
    }
}

public struct UpdateCollectionResult {
    
    public var insertedIndexPaths = [IndexPath]()
    public var insertedCellDescriptors = [CollectionCellDescribable]()
    
    public var deletedIndexPaths = [IndexPath]()
    public var deletedCellDescriptors = [CollectionCellDescribable]()
    
    public var reloadedIndexPaths = [IndexPath]()
    public var reloadedCellDescriptors = [CollectionCellDescribable]()
    
    public var insertedSectionsIndexSet = IndexSet()
    public var insertedSectionDescriptors = [CollectionSectionDescribable]()
    
    public var deletedSectionsIndexSet = IndexSet()
    public var deletedSectionDescriptors = [CollectionSectionDescribable]()
    
    public var reloadedSectionsIndexSet = IndexSet()
    public var reloadedSectionDescriptors = [CollectionSectionDescribable]()
}
