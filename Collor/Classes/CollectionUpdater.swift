//
//  CollectionUpdater.swift
//  Pods
//
//  Created by Guihal Gwenn on 05/04/17.
//
//

import Foundation
import Dwifft

public extension NSExceptionName {
    static let collorMissingSectionUID = NSExceptionName("collor.missingSectionUID")
    static let collorMissingItemUID = NSExceptionName("collor.missingItemUID")
    static let collorDuplicateItemUID = NSExceptionName("collor.duplicateItemUID")
    static let collorDuplicateSectionUID = NSExceptionName("collor.duplicateSectionUID")
}

final public class CollectionUpdater {
    
    var result:UpdateCollectionResult?
    
    unowned let collectionDatas:CollectionDatas
    
    init(collectionDatas:CollectionDatas) {
        self.collectionDatas = collectionDatas
    }
    
    public func diffSection(sectionDescriptor:CollectionSectionDescribable) {
        guard let sectionIndex = sectionDescriptor.index else {
            return
        }
        
        guard let sectionBuilder = sectionDescriptor.builder else {
            print("prout")
            return
        }
        
        let oldItems = sectionDescriptor.cells
        sectionDescriptor.cells.removeAll()
        sectionBuilder(&sectionDescriptor.cells)
        
        let old = oldItems.map{ $0._uid! }
        let new = sectionDescriptor.cells.map{ $0._uid! }
        
        Dwifft.diff(old, new).forEach {
            switch $0 {
            case let .delete(item, _):
                result?.deletedIndexPaths.append( IndexPath(item: item, section: sectionIndex ) )
                result?.deletedCellDescriptors.append( oldItems[item] )
            case let .insert(item, _):
                result?.insertedIndexPaths.append( IndexPath(item: item, section: sectionIndex ) )
                result?.insertedCellDescriptors.append( sectionDescriptor.cells[item] )
            }
        }
            
        collectionDatas.computeIndices()
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
                    result?.insertedCellDescriptors.append( collectionDatas.sections[section].cells[item] )
                case let .sectionDelete(section, _):
                    result?.deletedSectionsIndexSet.insert(section)
                    result?.deletedSectionDescriptors.append( oldSections[section] )
                case let .sectionInsert(section, _):
                    result?.insertedSectionsIndexSet.insert(section)
                    result?.insertedSectionDescriptors.append( collectionDatas.sections[section] )
                }
            }
            
            collectionDatas.computeIndices()
            
        } catch UIDError.sectionsWithoutUIDError(let sections) {
            let sectionsInError = sections.reduce("") { result, section in
                return result + "- section:\(section.0), description:\(section.1)\n"
            }
            NSException(name: .collorMissingSectionUID, reason: "No UID given for sections:\n \(sectionsInError)", userInfo: nil).raise()
        } catch UIDError.sectionsDuplicateError(let sections) {
            let sectionsInError = sections.reduce("") { result, section in
                return result + "- section:\(section.0), description:\(section.1)\n"
            }
            NSException(name: .collorDuplicateSectionUID, reason: "Duplicate for sections:\n \(sectionsInError)", userInfo: nil).raise()
        } catch UIDError.itemsWithoutUIDError(let items) {
            let itemsInError = items.reduce("") { result, item in
                return result + "- section: \(item.0), item:\(item.1), description:\(item.2)\n"
            }
            NSException(name: .collorMissingItemUID, reason: "No UID given for items:\n \(itemsInError)", userInfo: nil).raise()
        } catch UIDError.itemsDuplicateError(let items) {
            let itemsInError = items.reduce("") { result, item in
                return result + "- section: \(item.0), uid:\(item.1)\n"
            }
            NSException(name: .collorDuplicateItemUID, reason: "Duplicate for items:\n \(itemsInError)", userInfo: nil).raise()
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
        case itemsDuplicateError(items:[(Int,String)])
        case sectionsDuplicateError(items:[(Int,String)])
    }
    
    private func verifyUID(sections:[CollectionSectionDescribable]) throws {
        var sectionsWithoutUID = [(Int,CollectionSectionDescribable)]()
        var itemsWithoutUID = [(Int,Int,CollectionCellDescribable)]()
        var itemsDuplicateUID = [(Int,String)]()
        var sectionsDuplicateUID = [(Int,String)]()
        
        var setSections = Set<String>()
        
        for (sectionIndex, section) in sections.enumerated() {
            guard let sectionUID = section._uid else {
                sectionsWithoutUID.append( (sectionIndex,section) )
                continue
            }
            
            // duplicate sections
            let insertResult = setSections.insert(sectionUID)
            if insertResult.inserted == false {
                sectionsDuplicateUID.append( (sectionIndex, insertResult.memberAfterInsert) )
            }
            
            let cells = section.cells.enumerated().filter {
                return $0.element._uid == nil
            }.map {
                return (sectionIndex, $0.offset, $0.element)
            }
            itemsWithoutUID.append(contentsOf: cells)
            
            // duplicate items
            var setCells = Set<String>()
            section.cells.flatMap{ $0._uid }.forEach {
                let insertResult = setCells.insert($0)
                if insertResult.inserted == false {
                    itemsDuplicateUID.append( (sectionIndex, insertResult.memberAfterInsert) )
                }
            }
        }
        
        if !sectionsWithoutUID.isEmpty {
            throw UIDError.sectionsWithoutUIDError(sections: sectionsWithoutUID)
        } else if !sectionsDuplicateUID.isEmpty {
            throw UIDError.sectionsDuplicateError(items: sectionsDuplicateUID)
        } else if !itemsWithoutUID.isEmpty {
            throw UIDError.itemsWithoutUIDError(items: itemsWithoutUID)
        } else if !itemsDuplicateUID.isEmpty {
            throw UIDError.itemsDuplicateError(items: itemsDuplicateUID)
        }
    }
    
    public func append(cells:[CollectionCellDescribable], after cell:CollectionCellDescribable) {
        guard let indexPath = cell.indexPath else {
            return
        }
        guard let section = collectionDatas.sections[safe: indexPath.section] else {
            return
        }
        section.cells.insert(contentsOf: cells, at: indexPath.item + 1)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func append(cells:[CollectionCellDescribable], before cell:CollectionCellDescribable) {
        guard let indexPath = cell.indexPath else {
            return
        }
        guard let section = collectionDatas.sections[safe: indexPath.section] else {
            return
        }
        section.cells.insert(contentsOf: cells, at: indexPath.item)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func append(cells:[CollectionCellDescribable], in section:CollectionSectionDescribable) {
        section.cells.append(contentsOf: cells)
        collectionDatas.computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath! } ) // unwrapped because computeIndices() called before
    }
    
    public func remove(cells:[CollectionCellDescribable]) {
        var needTocomputeIndices = false
        cells.forEach { cellToDelete in
            guard let section = collectionDatas.sectionDescribable(for: cellToDelete) else {
                return
            }
            guard let indexPath = cellToDelete.indexPath else {
                return
            }
            guard let index = section.cells.index(where: {$0 === cellToDelete}) else {
                return
            }
            section.cells.remove(at: index)
            result?.deletedIndexPaths.append( indexPath )
            result?.deletedCellDescriptors.append(cellToDelete )
            needTocomputeIndices = true
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(cells:[CollectionCellDescribable]) {
        let cellsToReload = cells.filter{ $0.indexPath != nil }
        result?.reloadedIndexPaths.append(contentsOf: cellsToReload.map { $0.indexPath! } )
        result?.reloadedCellDescriptors.append(contentsOf: cellsToReload)
    }
    
    public func append(sections:[CollectionSectionDescribable], after section:CollectionSectionDescribable) {
        guard let sectionIndex = section.index else {
            return
        }
        collectionDatas.sections.insert(contentsOf: sections, at: sectionIndex + 1)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex + 1, upper: sectionIndex + 1 + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
        collectionDatas.computeIndices()
    }
    
    public func append(sections:[CollectionSectionDescribable], before section:CollectionSectionDescribable) {
        guard let sectionIndex = section.index else {
            return
        }
        collectionDatas.sections.insert(contentsOf: sections, at: sectionIndex)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex, upper: sectionIndex + sections.count)))
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
            guard let index = collectionDatas.sections.index(where: {$0 === sectionToDelete} ) else  {
                return
            }
            collectionDatas.sections.remove(at: index)
            result?.deletedSectionsIndexSet.insert(index)
            result?.deletedSectionDescriptors.append(sectionToDelete)
            needTocomputeIndices = true
        }
        if needTocomputeIndices {
            collectionDatas.computeIndices()
        }
    }
    
    public func reload(sections:[CollectionSectionDescribable]) {
        sections.forEach { (sectionToReload) in
            guard let index = collectionDatas.sections.index(where: {$0 === sectionToReload} ) else {
                return
            }
            result?.reloadedSectionsIndexSet.insert(index)
            result?.reloadedSectionDescriptors.append(sectionToReload)
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
