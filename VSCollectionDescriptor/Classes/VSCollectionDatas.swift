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
            compute()
            
            result?.insertedCellDescriptors.append(contentsOf: cells)
            result?.insertedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func remove(cells:[CollectionCellDescriptable]) {
        var needToCompute = false
        cells.forEach { (cellToDelete) in
            if let section = sections[safe: cellToDelete.indexPath.section] {
                if let index = section.cells.index(where: {$0 === cellToDelete} ) {
                    section.cells.remove(at: index)
                    result?.deletedIndexPaths.append( cellToDelete.indexPath )
                    result?.deletedCellDescriptors.append(cellToDelete )
                    needToCompute = true
                }
            }
        }
        if needToCompute {
            compute()
        }
    }
    
    public func reload(cells:[CollectionCellDescriptable]) {
        result?.reloadedIndexPaths.append(contentsOf: cells.map { $0.indexPath } )
        result?.reloadedCellDescriptors.append(contentsOf: cells)
    }
    
    public func append(sections:[CollectionSectionDescriptable], after section:CollectionSectionDescriptable) {
        if let sectionIndex = self.sections.index(where: { $0 === section }) {
            self.sections.insert(contentsOf: sections, at: sectionIndex + 1)
            
            result?.insertedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex + 1, upper: sectionIndex + 1 + sections.count)))
            result?.insertedSectionDescriptors.append(contentsOf: sections)
        }
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

