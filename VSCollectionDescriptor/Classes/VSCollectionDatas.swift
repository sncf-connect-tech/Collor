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
            compute()
        }
    }
    
    open func sectionsCount() -> Int {
        return sections.count
    }
    
    open func reloadData() { }
    
    fileprivate func compute() {
        
        for (sectionIndex, section) in sections.enumerated() {
            for (itemIndex, cell) in section.cells.enumerated() {
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
            compute()
            
            result?.appendedCellDescriptors.append(contentsOf: cells)
            result?.appendedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func remove(cells:[CollectionCellDescriptable]) {
        var needToCompute = false
        cells.forEach { (cellToDelete) in
            if let section = sections[safe: cellToDelete.indexPath.section] {
                if let index = section.cells.index(where: {$0 === cellToDelete} ) {
                    section.cells.remove(at: index)
                    result?.removedIndexPaths.append( cellToDelete.indexPath )
                    result?.removedCellDescriptors.append(cellToDelete )
                    needToCompute = true
                }
            }
        }
        if needToCompute {
            compute()
        }
    }
    
    public func append(sections:[CollectionSectionDescriptable], after section:CollectionSectionDescriptable) {
        if let sectionIndex = self.sections.index(where: { $0 === section }) {
            self.sections.insert(contentsOf: sections, at: sectionIndex + 1)
            
            result?.appenedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex + 1, upper: sectionIndex + 1 + sections.count)))
        }
    }
    
    public func remove(sections:[CollectionSectionDescriptable]) {
        sections.forEach { (sectionToDelete) in
            if let index = self.sections.index(where: {$0 === sectionToDelete} ) {
                self.sections.remove(at: index)
                result?.removedSectionsIndexSet.insert(index)
            }
        }
    }
    
    //TODO: add a reverse operation based on a result
    
}

public struct UpdateCollectionResult {
    
    public var appendedIndexPaths = [IndexPath]()
    public var appendedCellDescriptors = [CollectionCellDescriptable]()
    
    public var removedIndexPaths = [IndexPath]()
    public var removedCellDescriptors = [CollectionCellDescriptable]()
   
    public var appenedSectionsIndexSet = IndexSet()
    //TODO: add appenedSectionsDescriptors
    public var removedSectionsIndexSet = IndexSet()
    //TODO: add removedSectionsDescriptors
}

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

