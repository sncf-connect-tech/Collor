//
//  CollorDiffTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 11/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Collor

class CollorDiffTest: XCTestCase {
    
    struct KeyValue : Diffable {
        let key:String
        var value:Int
        
        func isEqual(to other: Diffable?) -> Bool {
            guard let other = other as? KeyValue else {
                return false
            }
            return value == other.value
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func map(_ a:[String]) -> [CollorDiff<Int, String>.DiffItem] {
        return a.enumerated().map { (index,value) -> CollorDiff<Int, String>.DiffItem in
            return (index,value,nil)
        }
    }
    
    private func map(_ a:[KeyValue]) -> [CollorDiff<Int, String>.DiffItem] {
        return a.enumerated().map { (index,value) -> CollorDiff<Int, String>.DiffItem in
            return (index,value.key,value)
        }
    }
    
    func testKeyDelete_first() {
        
        let oldArray = ["Anna","Baptiste","Clement"]
        let newArray = ["Baptiste","Clement"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.deleted, [0])
        XCTAssertEqual(diff.moved.debugDescription, [(from:1, to:0),(from:2, to:1)].debugDescription)
    }
    
    func testKeyDelete_middle() {
        
        let oldArray = ["Anna","Baptiste","Clement"]
        let newArray = ["Anna","Clement"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.deleted, [1])
        XCTAssertEqual(diff.moved.debugDescription, [(from:2, to:1)].debugDescription)
    }
    
    func testKeyDelete_last() {
        
        let oldArray = ["Anna","Baptiste","Clement"]
        let newArray = ["Anna","Baptiste"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
        
        XCTAssertEqual(diff.deleted, [2])
    }
    
    func testKeyInsert_last() {
        
        let oldArray = ["Anna","Baptiste","Clement"]
        let newArray = ["Anna","Baptiste","Clement","Damien"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
        
        XCTAssertEqual(diff.inserted, [3])
    }
    
    func testKeyInsert_first() {
        
        let oldArray = ["Anna","Baptiste"]
        let newArray = ["Damien","Anna","Baptiste"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.inserted, [0])
        XCTAssertEqual(diff.moved.debugDescription, [(from:0, to:1),(from:1, to:2)].debugDescription)
    }
    
    func testKeyInsert_middle() {
        
        let oldArray = ["Anna","Baptiste"]
        let newArray = ["Anna","Damien","Baptiste"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.inserted, [1])
        XCTAssertEqual(diff.moved.debugDescription, [(from:1, to:2)].debugDescription)
    }
    
    func testKeyMove() {
        
        let oldArray = ["Anna","Baptiste","Clement","Damien"]
        let newArray = ["Baptiste","Damien","Clement","Anna"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.inserted.isEmpty)
        
        XCTAssertEqual(diff.moved.debugDescription, [(from:0, to:3),(from:1, to:0),(from:3, to:1)].debugDescription)
    }
    
    func testKeyNoDiff() {
        
        let oldArray = ["Anna","Baptiste","Clement","Damien"]
        let newArray = ["Anna","Baptiste","Clement","Damien"]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
    }
    
    func testKeyValueDelete_first() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        
        let oldArray = [anna,baptiste,clement]
        let newArray = [baptiste,clement]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.deleted, [0])
        XCTAssertEqual(diff.moved.debugDescription, [(from:1, to:0),(from:2, to:1)].debugDescription)
    }
    
    func testKeyValueDelete_middle() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        
        let oldArray = [anna,baptiste,clement]
        let newArray = [anna,clement]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.deleted, [1])
        XCTAssertEqual(diff.moved.debugDescription, [(from:2, to:1)].debugDescription)
    }
    
    func testKeyValueDelete_last() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        
        let oldArray = [anna,baptiste,clement]
        let newArray = [anna,baptiste]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
        
        XCTAssertEqual(diff.deleted, [2])
    }
    
    func testKeyValueInsert_last() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        
        let oldArray = [anna,baptiste,clement]
        let newArray = [anna,baptiste,clement,damien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
        
        XCTAssertEqual(diff.inserted, [3])
    }
    
    func testKeyValueInsert_first() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        
        let oldArray = [anna,baptiste]
        let newArray = [damien,anna,baptiste]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.inserted, [0])
        XCTAssertEqual(diff.moved.debugDescription, [(from:0, to:1),(from:1, to:2)].debugDescription)
    }
    
    func testKeyValueInsert_middle() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        
        let oldArray = [anna,baptiste]
        let newArray = [anna,damien,baptiste]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        
        XCTAssertEqual(diff.inserted, [1])
        XCTAssertEqual(diff.moved.debugDescription, [(from:1, to:2)].debugDescription)
    }
    
    func testKeyValueMove() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)

        let oldArray = [anna,baptiste,clement,damien]
        let newArray = [baptiste,damien,clement,anna]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.inserted.isEmpty)
        
        XCTAssertEqual(diff.moved.debugDescription, [(from:0, to:3),(from:1, to:0),(from:3, to:1)].debugDescription)
    }
    
    func testKeyValueNoDiff() {
        
        let anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        
        let oldArray = [anna,baptiste,clement,damien]
        let newArray = [anna,baptiste,clement,damien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.reloaded.isEmpty)
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
    }
    
    func testKeyValueReload() {
        
        var anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        let clement = KeyValue(key: "Clement", value: 0)
        var damien = KeyValue(key: "Damien", value: 0)
        
        let oldArray = [anna,baptiste,clement,damien]
        damien.value = 2
        anna.value = 1
        let newArray = [anna,baptiste,clement,damien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertTrue(diff.deleted.isEmpty)
        XCTAssertTrue(diff.inserted.isEmpty)
        XCTAssertTrue(diff.moved.isEmpty)
        
        XCTAssertEqual(diff.reloaded, [0,3])
    }
    
    func testKeyValueDeleteInsertReloadMove() {
        
        var anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        var clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        let eric = KeyValue(key: "Eric", value: 0)
        
        let oldArray = [anna,baptiste,clement,eric]
        clement.value = 2 // clement will be deleted then inserted, not moved because its value has changed
        anna.value = 1
        let newArray = [anna,clement,eric,damien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertEqual(diff.inserted, [1,3])
        XCTAssertEqual(diff.reloaded, [0])
        XCTAssertEqual(diff.deleted, [1,2])
        XCTAssertEqual(diff.moved.debugDescription, [(from:3, to:2)].debugDescription)
    }
    
    func testKeyValueDeleteInsertReloadMoveBeforeSmaller() {
        
        var anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        var clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        let eric = KeyValue(key: "Eric", value: 0)
        let fabien = KeyValue(key: "Fabien", value: 0)
        
        let oldArray = [anna,baptiste,clement,eric]
        clement.value = 2 // clement will be deleted then inserted, not moved because its value has changed
        anna.value = 1
        let newArray = [anna,clement,eric,damien,fabien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertEqual(diff.inserted, [1,3,4])
        XCTAssertEqual(diff.reloaded, [0])
        XCTAssertEqual(diff.deleted, [2,1])
        XCTAssertEqual(diff.moved.debugDescription, [(from:3, to:2)].debugDescription)
    }
    
    func testKeyValueDeleteInsertReloadMoveAfterSmaller() {
        
        var anna = KeyValue(key: "Anna", value: 0)
        let baptiste = KeyValue(key: "Baptiste", value: 0)
        var clement = KeyValue(key: "Clement", value: 0)
        let damien = KeyValue(key: "Damien", value: 0)
        let eric = KeyValue(key: "Eric", value: 0)
        let fabien = KeyValue(key: "Fabien", value: 0)
        
        let oldArray = [anna,baptiste,clement,eric,fabien]
        clement.value = 2 // clement will be deleted then inserted, not moved because its value has changed
        anna.value = 1
        let newArray = [anna,clement,eric,damien]
        
        let diff = CollorDiff(before: map(oldArray), after: map(newArray))
        
        XCTAssertEqual(diff.inserted, [1,3])
        XCTAssertEqual(diff.reloaded, [0])
        XCTAssertEqual(diff.deleted, [1,2,4])
        XCTAssertEqual(diff.moved.debugDescription, [(from:3, to:2)].debugDescription)
    }
    
}
