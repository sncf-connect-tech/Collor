//
//  CollectionUpdaterDiffSectionTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest
import Collor
import CwlPreconditionTesting
import CwlCatchException

final class DiffSectionTestData: CollectionData {
    
    var deleted:Bool = false
    var insert:Bool = false
    
    override func reloadData() {
        super.reloadData()
        
        let sectionOne = TestSectionDescriptor().uid("section0").reloadSection { cells in
            cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
            cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
            cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
            
            if self.insert {
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell3") )
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell4") )
            }
        }
        sections.append(sectionOne)
        
        let sectionTwo = SimpleTestSectionDescriptor().uid("section1").reloadSection { cells in
            if !self.deleted {
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
            }
            cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
        }
        sections.append(sectionTwo)
    }
}


class CollectionUpdaterDiffSectionTest: XCTestCase {
    
    var data:DiffSectionTestData!
    
    override func setUp() {
        super.setUp()
        
        data = DiffSectionTestData()
        data.reloadData()
        data.computeIndices() // not linked with collectionView
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiffSection_deleteCells() {
        // given
        let sectionIndex = 1
        let sectionDescriptor = data.sections[sectionIndex]
        let cellOne = data.sections[sectionIndex].cells[0]
        let cellTwo = data.sections[sectionIndex].cells[1]
        
        // when
        data.deleted = true
        let result = data.update { (updater) in
            updater.diff(sections: [sectionDescriptor])
        }
        
        // then
        XCTAssertTrue(result.insertedCellDescriptors.isEmpty)
        XCTAssertTrue(result.insertedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.deletedCellDescriptors.count, 2)
        XCTAssertTrue(result.deletedCellDescriptors[0] === cellOne)
        XCTAssertTrue(result.deletedCellDescriptors[1] === cellTwo)
        XCTAssertEqual(result.deletedIndexPaths,[ IndexPath(item: 0, section: sectionIndex), IndexPath(item: 1, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 1 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
    }
    
    func testDiffSection_insertCells() {
        // given
        let sectionIndex = 0
        let sectionDescriptor = data.sections[sectionIndex]
        
        // when
        data.insert = true
        let result = data.update { (updater) in
            updater.diff(sections: [sectionDescriptor])
        }
        
        // then
        XCTAssertTrue(result.deletedCellDescriptors.isEmpty)
        XCTAssertTrue(result.deletedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedCellDescriptors.count, 2)
        XCTAssertEqual(result.insertedIndexPaths,[ IndexPath(item: 3, section: sectionIndex), IndexPath(item: 4, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 5 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
        XCTAssertEqual(data.sections[sectionIndex].cells[1].indexPath, IndexPath(item: 1, section: sectionIndex) )
    }
    
    func testDiffSection_multiple() {
        // given
        let sectionDescriptors = data.sections
        
        // when
        data.deleted = true
        data.insert = true
        let result = data.update { (updater) in
            updater.diff(sections: sectionDescriptors)
        }
        
        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        
        XCTAssertEqual(result.deletedCellDescriptors.count, 2)
        XCTAssertEqual(result.deletedIndexPaths.count, 2)
        
        XCTAssertEqual(result.insertedCellDescriptors.count, 2)
        XCTAssertEqual(result.insertedIndexPaths.count, 2)
        
        XCTAssertEqual(data.sections.count, 2)
        
        XCTAssertEqual(data.sections[0].cells.count, 5)
        XCTAssertEqual(data.sections[0].cells[0].indexPath, IndexPath(item: 0, section: 0))
        XCTAssertEqual(data.sections[1].cells.count, 1)
        XCTAssertEqual(data.sections[1].cells[0].indexPath, IndexPath(item: 0, section: 1))
    }
    
    func testDiffSection_missingSectionIndex() {
        #if arch(x86_64) || arch(i386)
            // given
            data = DiffSectionTestData()
            data.reloadData()
            // don't call computeIndices
            let cellOne = TestCellDescriptor(adapter: TestAdapter() )
            let sectionDescriptor = data.sections[0]
            
            // when
            sectionDescriptor.reloadSection { cells in
                cells.append( cellOne )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff(sections: [sectionDescriptor])
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorSectionIndexNil)
        #endif
    }
    
    func testDiffSection_missingSectionBuilder() {
        #if arch(x86_64) || arch(i386)
            // given
            let sectionDescriptor = TestSectionDescriptor().uid("section")
            data.sections.append(sectionDescriptor)
            data.computeIndices()
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff(sections: [sectionDescriptor])
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorSectionBuilderNil)
        #endif
    }
    
    func testDiffSection_missingItemUID() {
        #if arch(x86_64) || arch(i386)
            // given
            let cellOne = TestCellDescriptor(adapter: TestAdapter() )
            let sectionDescriptor = data.sections[0]
            
            // when
            sectionDescriptor.reloadSection { cells in
                cells.append( cellOne )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff(sections: [sectionDescriptor])
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorMissingItemUID)
        #endif
    }
    
    func testDiffSection_duplicateItemsUID() {
        #if arch(x86_64) || arch(i386)
            // given
            let sectionDescriptor = data.sections[0]
            let cellOne = TestCellDescriptor(adapter: TestAdapter() ).uid("cell0")
            let cellTwo = TestCellDescriptor(adapter: TestAdapter() ).uid("cell0")
            
            // when
            sectionDescriptor.reloadSection { cells in
                cells.append( cellOne )
                cells.append( cellTwo )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff(sections: [sectionDescriptor])
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorDuplicateItemUID)
        #endif
    }
    
}
