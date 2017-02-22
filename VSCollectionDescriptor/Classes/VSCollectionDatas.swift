//
//  VSCollectionDatas.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright © 2017 VSCT. All rights reserved.
//

import Foundation

open class VSCollectionDatas {
    
    public weak var collectionView:UICollectionView? {
        didSet {
            compute()
        }
    }
    
    public init() {}
    
    public var sections = [VSCollectionSectionDescriptor]() {
        didSet {
            compute()
        }
    }
    
    public func sectionsCount() -> Int {
        return sections.count
    }
    
    open func reloadData() { }
    
    fileprivate func compute() {
        
        var registrationsSet = Set<CellData>()
        
        for (sectionIndex, section) in sections.enumerated() {
            for (itemIndex, cell) in section.cells.enumerated() {
                registrationsSet.insert( CellData(identifier:cell.identifier, className:cell.className) )
                cell.indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        
        registrationsSet.forEach { (cellData) in
            let nib = UINib(nibName: cellData.className, bundle: nil)
            collectionView?.register(nib, forCellWithReuseIdentifier: cellData.identifier)
        }
    }
    
    private(set) var appendedCells = [IndexPath]()
    private(set) var removedCells = [IndexPath]()
    
    public func beginUpdate() {
        appendedCells.removeAll()
        removedCells.removeAll()
    }
    
    public func append(cells:[VSCollectionCellDescriptor], after cell:VSCollectionCellDescriptor) {
        if let section = sections.first(where: { $0.cells.contains(where: { $0 === cell })}), var index = section.cells.index(where: { $0 === cell }) {
            section.cells.insert(contentsOf: cells, at: index + 1)
            compute()
            appendedCells.append(contentsOf:  cells.map{ $0.indexPath } )
        }
        
    }
    
    public func remove(cells:[VSCollectionCellDescriptor]) {
        
    }
    
    public func endUpdate() -> UpdateCollectionResult {
        return UpdateCollectionResult(appendedIndexPaths: appendedCells,
                                      removedIndexPaths: removedCells)
    }

}

public struct UpdateCollectionResult {
    public let appendedIndexPaths:[IndexPath]
    public let removedIndexPaths:[IndexPath]
}

fileprivate struct CellData: Hashable {
    
    let identifier: String
    let className: String
    
    init(identifier: String, className: String) {
        self.identifier = identifier
        self.className = className
    }
    
    static func == (data1: CellData, data2: CellData) -> Bool {
        return data1.identifier == data2.identifier && data1.className == data2.className
    }
    
    var hashValue: Int {
        return identifier.hashValue ^ className.hashValue
        
    }
    
}

