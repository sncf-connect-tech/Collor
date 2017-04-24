//
//  CollectionUpdater.swift
//  Pods
//
//  Created by Guihal Gwenn on 05/04/17.
//
//

import Foundation

final public class CollectionUpdater {
    
    var result:UpdateCollectionResult?
    
    unowned let collectionDatas:CollectionDatas
    
    init(collectionDatas:CollectionDatas) {
        self.collectionDatas = collectionDatas
    }
    
    public func append(cells:[CollectionCellDescribable], after cell:CollectionCellDescribable) {
        if let section = collectionDatas.sections[safe: cell.indexPath.section] {
            section.cells.insert(contentsOf: cells, at: cell.indexPath.item + 1)
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
    }
    
    public func append(sections:[CollectionSectionDescribable]) {
        let oldSectionsCount = collectionDatas.sections.count
        collectionDatas.sections.append(contentsOf: sections)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: oldSectionsCount, upper: oldSectionsCount + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
    }
    
    public func remove(sections:[CollectionSectionDescribable]) {
        sections.forEach { (sectionToDelete) in
            if let index = collectionDatas.sections.index(where: {$0 === sectionToDelete} ) {
                collectionDatas.sections.remove(at: index)
                result?.deletedSectionsIndexSet.insert(index)
                result?.deletedSectionDescriptors.append(sectionToDelete)
            }
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
