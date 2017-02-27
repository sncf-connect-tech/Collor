//
//  VSCollectionDatas.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright © 2017 VSCT. All rights reserved.
//

import Foundation

open class VSCollectionDatas {
    
    var registeredCells = Set<String>()
    
    public init() {}
    
    public var sections = [VSCollectionSectionDescriptor]() {
        didSet {
            compute()
        }
    }
    
    open func sectionsCount() -> Int {
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
    }
    
    //MARK: Updates
    
    fileprivate var lock:Bool = false // alow or disallow updating datas
    fileprivate var result:UpdateCollectionResult!
    
    public func update(_ updates: () -> Void) -> UpdateCollectionResult {
        result = UpdateCollectionResult()
        lock = true
        updates()
        lock = false
        return result
    }
    
    public func append(cells:[VSCollectionCellDescriptor], after cell:VSCollectionCellDescriptor) {
        checkLock()
        if let section = sections[safe: cell.indexPath.section] {
            section.cells.insert(contentsOf: cells, at: cell.indexPath.item + 1)
            compute()
            
            result.appendedCellDescriptors.append(contentsOf: cells)
            result.appendedIndexPaths.append(contentsOf: cells.map{ $0.indexPath } )
        }
    }
    
    public func remove(cells:[VSCollectionCellDescriptor]) {
        checkLock()
        var needToCompute = false
        cells.forEach { (cellToDelete) in
            if let section = sections[safe: cellToDelete.indexPath.section] {
                if let index = section.cells.index(where: {$0 === cellToDelete} ) {
                    section.cells.remove(at: index)
                    result.removedIndexPaths.append( cellToDelete.indexPath )
                    result.removedCellDescriptors.append(cellToDelete )
                    needToCompute = true
                }
            }
        }
        if needToCompute {
            compute()
        }
    }
    
    public func append(sections:[VSCollectionSectionDescriptor], after section:VSCollectionSectionDescriptor) {
        checkLock()
        if let sectionIndex = self.sections.index(where: { $0 === section }) {
            self.sections.insert(contentsOf: sections, at: sectionIndex + 1)
            
            result.appenedSectionsIndexSet.insert(integersIn: Range(uncheckedBounds: (lower: sectionIndex + 1, upper: sectionIndex + 1 + sections.count)))
        }
    }
    
    public func remove(sections:[VSCollectionSectionDescriptor]) {
        checkLock()
        sections.forEach { (sectionToDelete) in
            if let index = self.sections.index(where: {$0 === sectionToDelete} ) {
                self.sections.remove(at: index)
                result.removedSectionsIndexSet.insert(index)
            }
        }
    }
    
    //TODO: add a reverse operation based on a result
    
    fileprivate func checkLock() {
        assert(lock == true, "Updading datas can only be done in an update closure")
    }
}

public struct UpdateCollectionResult {
    
    public var appendedIndexPaths = [IndexPath]()
    public var appendedCellDescriptors = [VSCollectionCellDescriptor]()
    
    public var removedIndexPaths = [IndexPath]()
    public var removedCellDescriptors = [VSCollectionCellDescriptor]()
   
    public var appenedSectionsIndexSet = IndexSet()
    //TODO: add appenedSectionsDescriptor
    public var removedSectionsIndexSet = IndexSet()
    //TODO: add removedSectionsDescriptor
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

extension Collection where Indices.Iterator.Element == Index {
    
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

