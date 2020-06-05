//
//  CollectionDataTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 03/05/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest
@testable import Collor

class CollectionDataTest: XCTestCase {
    
    var data:TestData!
    
    override func setUp() {
        super.setUp()
        
        data = TestData()
        data.reloadData()
        data.computeIndices() // not linked with collectionView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetSectionDescribableAtIndexPath() {
        // given
        let indexPath = IndexPath(item: 0, section: 1)
        // when
        let sectionDescriptor = data.sectionDescribable(at: indexPath)
        // then
        XCTAssertTrue(sectionDescriptor === data.sections[1])
    }
    
    func testGetSectionDescribableAtIndexPathNil() {
        // given
        let indexPath = IndexPath(item: 0, section: 10)
        // when
        let sectionDescriptor = data.sectionDescribable(at: indexPath)
        // then
        XCTAssertNil(sectionDescriptor)
    }
    
    func testGetSectionDescribableForCell() {
        // given
        let cellDescriptor = data.sections[1].cells[2]
        // when
        let sectionDescriptor = data.sectionDescribable(for: cellDescriptor)
        // then
        XCTAssertTrue(sectionDescriptor === data.sections[1])
    }
    
    func testGetCellDescribable() {
        // given
        let indexPath = IndexPath(item: 1, section: 0)
        // when
        let cellDescriptor = data.cellDescribable(at: indexPath)
        // then
        XCTAssertTrue(cellDescriptor === data.sections[0].cells[1])
    }
    
    func testGetCellDescribableNil() {
        // given
        let indexPath = IndexPath(item: 20, section: 3)
        // when
        let cellDescriptor = data.cellDescribable(at: indexPath)
        // then
        XCTAssertNil(cellDescriptor)
    }
    
    func testGetSupplementaryViewDescribableNil() {
        // given
        let indexPath = IndexPath(item: 1, section: 8)
        // when
        let descriptor = data.supplementaryViewDescribable(at: indexPath, for: "test")
        // then
        XCTAssertNil(descriptor)
    }
    
    func testGetSupplementaryViewDescribable() {
        // given
        let indexPath = IndexPath(item: 1, section: 2)
        // when
        let descriptor = data.supplementaryViewDescribable(at: indexPath, for: "test")
        // then
        XCTAssertTrue(descriptor === data.sections[2].supplementaryViews["test"]?[1])
    }
    
    
    func testGetSupplementaryViewDescribableIndexPath() {
        // given
        let indexPath = IndexPath(item: 1, section: 2)
        // when
        let descriptor = data.supplementaryViewDescribable(at: indexPath, for: "test")
        // then
        XCTAssertEqual(descriptor?.indexPath, indexPath)
    }
    
    
}
