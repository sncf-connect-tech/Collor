//
//  CollectionUpdaterReloadDataTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 21/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Collor
import CwlPreconditionTesting
import CwlCatchException

final class ReloadTestData:CollectionDatas {
    
    var deleted:Bool = false
    var deletedSection:Bool = false
    var insert:Bool = false
    var insertSection:Bool = false
    
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        if !deletedSection {
            let sectionOne = TestSectionDescriptor().uid("section0")
            sectionOne.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
            sectionOne.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
            sectionOne.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
            if insert {
                sectionOne.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell3") )
                sectionOne.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell4") )
            }
            sections.append(sectionOne)
        }
        
        if insertSection {
            let sectionPlus = TestSectionDescriptor().uid("sectionPlus")
            sectionPlus.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
            sections.append(sectionPlus)
        }
        
        let sectionTwo = SimpleTestSectionDescriptor().uid("section1")
        if !deleted {
            sectionTwo.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
            sectionTwo.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
        }
        sectionTwo.cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
        
        sections.append(sectionTwo)
    }
}

class CollectionUpdaterReloadDataTest: XCTestCase {
    
    var data:ReloadTestData!
    
    override func setUp() {
        super.setUp()
        
        data = ReloadTestData()
        data.reloadData()
        data.computeIndices() // not linked with collectionView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReloadData_deleteCells() {
        // given
        let sectionIndex = 1
        let cellOne = data.sections[sectionIndex].cells[0]
        let cellTwo = data.sections[sectionIndex].cells[1]
        
        // when
        data.deleted = true
        let result = data.update { (updater) in
            updater.reloadData()
        }
        
        // then
        XCTAssertTrue(result.insertedCellDescriptors.isEmpty)
        XCTAssertTrue(result.insertedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.deletedCellDescriptors.count, 2)
        XCTAssertTrue(result.deletedCellDescriptors[0] === cellTwo)
        XCTAssertTrue(result.deletedCellDescriptors[1] === cellOne)
        XCTAssertEqual(result.deletedIndexPaths,[ IndexPath(item: 1, section: sectionIndex), IndexPath(item: 0, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 1 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
    }
    
    func testReloadData_deleteSection() {
        // given
        let section = data.sections[0]
        
        // when
        data.deletedSection = true
        let result = data.update { (updater) in
            updater.reloadData()
        }
        
        // then
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.deletedSectionDescriptors.count, 1)
        XCTAssertTrue(result.deletedSectionDescriptors[0] === section)
        XCTAssertEqual(result.deletedSectionsIndexSet, IndexSet(integer: 0))
        
        XCTAssertEqual(data.sections.count, 1)
        XCTAssertEqual(data.sections[0].cells[0].indexPath, IndexPath(item: 0, section: 0))
    }
    
    func testReloadData_insertCells() {
        // given
        let sectionIndex = 0
        
        // when
        data.insert = true
        let result = data.update { (updater) in
            updater.reloadData()
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
    
    func testReloadData_insertSection() {
        // given
        
        // when
        data.insertSection = true
        let result = data.update { (updater) in
            updater.reloadData()
        }
        
        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedSectionDescriptors.count, 1)
        XCTAssertEqual(result.insertedSectionsIndexSet, IndexSet(integer: 1))
        XCTAssertEqual(data.sections[1].cells[0].indexPath, IndexPath(item: 0, section: 1))
        XCTAssertEqual(data.sections[0].cells[0].indexPath, IndexPath(item: 0, section: 0))
        XCTAssertEqual(data.sections[2].cells[2].indexPath, IndexPath(item: 2, section: 2))
    }
    
    func testReloadData_multiple() {
        // given
        
        // when
        data.insertSection = true
        data.deleted = true
        data.insert = true
        let result = data.update { (updater) in
            updater.reloadData()
        }
        
        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.deletedCellDescriptors.count, 2)
        XCTAssertEqual(result.deletedIndexPaths.count, 2)

        
        XCTAssertEqual(result.insertedCellDescriptors.count, 3)
        XCTAssertEqual(result.insertedIndexPaths.count, 3)
        
        XCTAssertEqual(result.insertedSectionsIndexSet, IndexSet(integer: 1))
        XCTAssertEqual(result.insertedSectionDescriptors.count, 1)

        XCTAssertEqual(data.sections.count, 3)
        
        XCTAssertEqual(data.sections[0].cells.count, 5)
        XCTAssertEqual(data.sections[0].cells[0].indexPath, IndexPath(item: 0, section: 0))
        XCTAssertEqual(data.sections[1].cells.count, 1)
        XCTAssertEqual(data.sections[1].cells[0].indexPath, IndexPath(item: 0, section: 1))
        XCTAssertEqual(data.sections[2].cells.count, 1)
        XCTAssertEqual(data.sections[2].cells[0].indexPath, IndexPath(item: 0, section: 2))
    }
    
    func testReloadData_missingSectionUID() {
        #if arch(x86_64) || arch(i386)
        // given
        
        // when
        data.sections.append( TestSectionDescriptor() )
            
        // then
            let exception = NSException.catchException {
            let _ = data.update { (updater) in
                updater.reloadData()
            }
        }
        XCTAssertNotNil(exception)
        XCTAssertEqual(exception?.name, NSExceptionName.collorMissingSectionUID)
        #endif
    }
    
    func testReloadData_duplicatesSectionsUID() {
        #if arch(x86_64) || arch(i386)
            // given
            
            // when
            data.sections.append( TestSectionDescriptor().uid("section") )
            data.sections.append( TestSectionDescriptor().uid("section") )
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.reloadData()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorDuplicateSectionUID)
        #endif
    }
    
    func testReloadData_missingItemUID() {
        #if arch(x86_64) || arch(i386)
            // given
            
            // when
            let cellOne = TestCellDescriptor(adapter: TestAdapter() )
            data.sections[0].build{ cells in
                cells.append( cellOne )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.reloadData()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorMissingItemUID)
        #endif
    }
    
    func testReloadData_duplicateItemsUID() {
        #if arch(x86_64) || arch(i386)
            // given
            
            // when
            let cellOne = TestCellDescriptor(adapter: TestAdapter() ).uid("cell0")
            data.sections[0].build { cells in
                cells.append( cellOne )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.reloadData()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorDuplicateItemUID)
        #endif
    }
    
}
