//
//  CollectionDatas.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright © 2017 VSCT. All rights reserved.
//

import Foundation

public protocol CollectionDatasProtocol {
    var updater:CollectionUpdater { get set }
    var sections:[CollectionSectionDescribable] { get set }
    func reloadData()
}

open class CollectionDatas : CollectionDatasProtocol {
    
    public lazy var updater:CollectionUpdater = CollectionUpdater(collectionDatas: self)
    
    public init() {}
    
    public var sections = [CollectionSectionDescribable]()
    
    open func reloadData() { }
    
    //MARK: Internal
    
    internal var registeredCells = Set<String>()
    
    internal func sectionsCount() -> Int {
        return sections.count
    }
    
    internal func computeIndices() {
        for (sectionIndex, section) in sections.enumerated() {
            section.index = sectionIndex
            for (itemIndex, cell) in section.cells.enumerated() {
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
    
    public func sectionDescribable(at indexPath: IndexPath) -> CollectionSectionDescribable? {
        return sections[safe: indexPath.section]
    }
    public func sectionDescribable(for cellDescribable: CollectionCellDescribable) -> CollectionSectionDescribable? {
        return sections[safe: cellDescribable.indexPath.section]
    }
    public func cellDescribable(at indexPath: IndexPath) -> CollectionCellDescribable? {
        return sections[safe: indexPath.section]?.cells[indexPath.item]
    }
}

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

