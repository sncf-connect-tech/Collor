//
//  CollectionDatas.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright © 2017 VSCT. All rights reserved.
//

import Foundation

open class CollectionDatas {
    
    var registeredCells = Set<String>()
    
    public init() {}
    
    public var sections = [CollectionSectionDescriptable]() {
        didSet {
            computeIndices()
        }
    }
    
    open func sectionsCount() -> Int {
        return sections.count
    }
    
    open func reloadData() { }
    
    fileprivate func computeIndices() {
        
        for (sectionIndex, var section) in sections.enumerated() {
            section.index = sectionIndex
            for (itemIndex, var cell) in section.cells.enumerated() {
                cell.indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
    }
    
    //MARK: Updates
    
    fileprivate var result:UpdateCollectionResult?
    
    public func update(_ updates: () -> Void) -> UpdateCollectionResult {
        result = UpdateCollectionResult()
        updates()
        return result!
    }
    
    public func append(cells:[CollectionCellDescriptable], after cell:CollectionCellDescriptable) {
        if let section = sections[safe: cell.indexPath.section] {
            section.cells.insert(contentsOf: cells, at: cell.indexPath.item + 1)
            computeIndices()
            
            result?.insertedCellDescriptors.append(contentsOf: cells)
            result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func append(cells:[CollectionCellDescriptable], in section:CollectionSectionDescriptable) {
        section.cells.append(contentsOf: cells)
        computeIndices()
        
        result?.insertedCellDescriptors.append(contentsOf: cells)
        result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
    }
    
    public func remove(cells:[CollectionCellDescriptable]) {
        var needTocomputeIndices = false
        cells.forEach { (cellToDelete) in
            if let section = sectionDescriptable(for: cellToDelete) {
                if let index = section.cells.index(where: {$0 === cellToDelete} ) {
                    section.cells.remove(at: index)
                    result?.deletedIndexPaths.append( cellToDelete.indexPath )
                    result?.deletedCellDescriptors.append(cellToDelete )
                    needTocomputeIndices = true
                }
            }
        }
        if needTocomputeIndices {
            computeIndices()
        }
    }
    
    public func reload(cells:[CollectionCellDescriptable]) {
        result?.reloadedIndexPaths.append(contentsOf: cells.map { $0.indexPath } )
        result?.reloadedCellDescriptors.append(contentsOf: cells)
    }
    
    public func append(sections:[CollectionSectionDescriptable], after section:CollectionSectionDescriptable) {
        self.sections.insert(contentsOf: sections, at: section.index + 1)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: section.index + 1, upper: section.index + 1 + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
    }
    
    public func append(sections:[CollectionSectionDescriptable]) {
        let oldSectionsCount = self.sections.count
        self.sections.append(contentsOf: sections)
        result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: oldSectionsCount, upper: oldSectionsCount + sections.count)))
        result?.insertedSectionDescriptors.append(contentsOf: sections)
    }
    
    public func remove(sections:[CollectionSectionDescriptable]) {
        sections.forEach { (sectionToDelete) in
            if let index = self.sections.index(where: {$0 === sectionToDelete} ) {
                self.sections.remove(at: index)
                result?.deletedSectionsIndexSet.insert(index)
                result?.deletedSectionDescriptors.append(sectionToDelete)
            }
        }
    }
    
    public func reload(sections:[CollectionSectionDescriptable]) {
        sections.forEach { (sectionToReload) in
            if let index = self.sections.index(where: {$0 === sectionToReload} ) {
                result?.reloadedSectionsIndexSet.insert(index)
                result?.reloadedSectionDescriptors.append(sectionToReload)
            }
        }
    }
}

public extension CollectionDatas {
    
    public func sectionDescriptable(at indexPath: IndexPath) -> CollectionSectionDescriptable? {
        return sections[safe: indexPath.section]
    }
    public func sectionDescriptable(for cellDescriptable: CollectionCellDescriptable) -> CollectionSectionDescriptable? {
        return sections[safe: cellDescriptable.indexPath.section]
    }
    public func cellDescriptable(at indexPath: IndexPath) -> CollectionCellDescriptable? {
        return sections[safe: indexPath.section]?.cells[indexPath.item]
    }
}

public struct UpdateCollectionResult {
    
    public var insertedIndexPaths = [IndexPath]()
    public var insertedCellDescriptors = [CollectionCellDescriptable]()
    
    public var deletedIndexPaths = [IndexPath]()
    public var deletedCellDescriptors = [CollectionCellDescriptable]()
    
    public var reloadedIndexPaths = [IndexPath]()
    public var reloadedCellDescriptors = [CollectionCellDescriptable]()
    
   
    public var insertedSectionsIndexSet = IndexSet()
    public var insertedSectionDescriptors = [CollectionSectionDescriptable]()

    public var deletedSectionsIndexSet = IndexSet()
    public var deletedSectionDescriptors = [CollectionSectionDescriptable]()
    
    public var reloadedSectionsIndexSet = IndexSet()
    public var reloadedSectionDescriptors = [CollectionSectionDescriptable]()
}

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

