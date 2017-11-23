//
//  CollectionSectionDescribableTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 15/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor

class CollectionSectionDescribableTest: XCTestCase {
    func testUID_sectionUIDNil() {
        
        let cell = TestCellDescriptor(adapter: TestAdapter()).uid("test")
        
        let section = TestSectionDescriptor().reloadSection { cells in
            cells.append(cell)
        }
        
        XCTAssertNil(section.uid(for: cell))
    }
    
    func testUID_cellUIDNil() {
        
        let cell = TestCellDescriptor(adapter: TestAdapter())
        
        let section = TestSectionDescriptor().uid("test").reloadSection { cells in
            cells.append(cell)
        }
        
        XCTAssertNil(section.uid(for: cell))
    }
    
    func testUID() {
        
        let cell = TestCellDescriptor(adapter: TestAdapter()).uid("cell")
        
        let section = TestSectionDescriptor().uid("section").reloadSection { cells in
            cells.append(cell)
        }
        
        XCTAssertEqual(section.uid(for: cell), "section/cell")
    }

}
