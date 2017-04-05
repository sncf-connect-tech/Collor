//
//  CollectionDatas.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright © 2017 VSCT. All rights reserved.
//

import Foundation

open class CollectionDatas {
    
    public lazy var updater:CollectionUpdater = CollectionUpdater(collectionDatas: self)
    
    public init() {}
    
    public var sections = [CollectionSectionDescriptable]()
    
    open func reloadData() { }
    
    internal var registeredCells = Set<String>()
    
    internal func sectionsCount() -> Int {
        return sections.count
    }
    
    internal func computeIndices() {
        
        for (sectionIndex, var section) in sections.enumerated() {
            section.index = sectionIndex
            for (itemIndex, var cell) in section.cells.enumerated() {
                cell.indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
    }
    
    //MARK: Update
    
    public func update(_ updates: (_ updater:CollectionUpdater) -> Void) -> UpdateCollectionResult {
        updater.result = UpdateCollectionResult()
        updates(updater)
        return updater.result!
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

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

