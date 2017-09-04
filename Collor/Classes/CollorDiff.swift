//
//  CollorDiff.swift
//  Pods
//
//  Created by Guihal Gwenn on 01/09/2017.
//
//

import Foundation

struct CollorDiff<I:Equatable, T : Hashable> {
    public typealias DiffItem = (index:I,value:T)
    typealias DiffList = [I]
    typealias FromToList = [(from: I, to: I)]
    
    let inserted: DiffList
    let deleted: DiffList
    let moved: FromToList
    
    init(before: [DiffItem], after: [DiffItem]) {
        let beforeIsSmaller = before.count < after.count
        var map = [T: I]()
        for item in (beforeIsSmaller ? before : after) {
            map[item.value] = item.index
        }
        
        var inserted = DiffList()
        var deleted = DiffList()
        var moved = FromToList()
        
        (beforeIsSmaller ? after : before).forEach { (index,value) in
            let index1 = index
            if let index2 = map[value] {
                if (index1 != index2) {
                    let (from, to) = beforeIsSmaller ? (index2, index1) : (index1, index2)
                    moved.append((from: from, to: to))
                }
                map.removeValue(forKey: value)
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
                deleted.append($0)
            } else {
                inserted.append($0)
            }
        }
        
        self.inserted = inserted
        self.deleted = deleted
        self.moved = moved
    }
}
