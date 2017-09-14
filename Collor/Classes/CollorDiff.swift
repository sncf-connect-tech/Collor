//
//  CollorDiff.swift
//  Pods
//
//  Created by Guihal Gwenn on 01/09/2017.
//
//

import Foundation

public struct CollorDiff<I:Equatable, T : Hashable> {
        
    public typealias DiffItem = (index: I, key: T, value:Diffable?)
    public typealias DiffList = [I]
    public typealias FromToList = [(from: I, to: I)]
    
    public let inserted: DiffList
    public let deleted: DiffList
    public let reloaded: DiffList
    public let moved: FromToList
    
    public init(before: [DiffItem], after: [DiffItem]) {
        
        typealias MapItem = (index:I,value:Diffable?)
        
        let beforeIsSmaller = before.count < after.count
        var map = [T: MapItem]()
        for item in (beforeIsSmaller ? before : after) {
            map[item.key] = (item.index,item.value)
        }
        
        var inserted = DiffList()
        var deleted = DiffList()
        var reloaded = DiffList()
        var moved = FromToList()
        
        let isValueUpdated:(DiffItem) -> Bool = {
            if let value1 = $0.value, let value2 = map[$0.key]?.value, !value1.isEqual(to: value2) {
                return true
            }
            return false
        }
        
        (beforeIsSmaller ? after : before).forEach {
            let index1 = $0.index
            if let index2 = map[$0.key]?.index {
                if (index1 != index2) {
                    if isValueUpdated($0) {
                        deleted.append(beforeIsSmaller ? index2 : index1)
                        inserted.append(beforeIsSmaller ? index1 : index2)
                    } else {
                        let (from, to) = beforeIsSmaller ? (index2, index1) : (index1, index2)
                        moved.append((from: from, to: to))
                    }
                } else {
                    if isValueUpdated($0) {
                        reloaded.append(index1)
                    }
                }
                map.removeValue(forKey: $0.key)
            } else {
                if (beforeIsSmaller) {
                    inserted.append(index1)
                } else {
                    deleted.append(index1)
                }
            }
        }
        
        map.values.forEach {
            if (beforeIsSmaller) {
                deleted.append($0.index)
            } else {
                inserted.append($0.index)
            }
        }
        
        self.inserted = inserted
        self.deleted = deleted
        self.moved = moved
        self.reloaded = reloaded
    }
}
