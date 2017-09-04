//
//  CollectionUpdaterReloadDataTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 21/06/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest
import Collor
import CwlPreconditionTesting
import CwlCatchException

final class DiffTestData:CollectionData {
    
    var deleted:Bool = false
    var deletedSection:Bool = false
    var insert:Bool = false
    var insertSection:Bool = false
    
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        if !deletedSection {
            let sectionOne = TestSectionDescriptor().uid("section0")
            sectionOne.reloadSection { cells in
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
                
                if self.insert {
                    cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell3") )
                    cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell4") )
                }
            }
            
            sections.append(sectionOne)
        }
        
        if insertSection {
            let sectionPlus = TestSectionDescriptor().uid("sectionPlus")
            sectionPlus.reloadSection { cells in
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
            }
            sections.append(sectionPlus)
        }
        
        let sectionTwo = SimpleTestSectionDescriptor().uid("section1")
        
        sectionTwo.reloadSection { cells in
            if !self.deleted {
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell0") )
                cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell1") )
            }
            cells.append( TestCellDescriptor(adapter: TestAdapter() ).uid("cell2") )
        }
        sections.append(sectionTwo)
    }
}

class CollectionUpdaterReloadDataTest: XCTestCase {
    
    var data:DiffTestData!
    
    override func setUp() {
        super.setUp()
        
        data = DiffTestData()
        data.reloadData()
        data.computeIndices() // not linked with collectionView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDiffData_deleteCells() {
        // given
        let sectionIndex = 1
        let cellOne = data.sections[sectionIndex].cells[0]
        let cellTwo = data.sections[sectionIndex].cells[1]
        
        // when
        data.deleted = true
        let result = data.update { (updater) in
            updater.diff()
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
    
    func testDiffData_deleteSection() {
        // given
        let section = data.sections[0]
        
        // when
        data.deletedSection = true
        let result = data.update { (updater) in
            updater.diff()
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
    
    func testDiffData_insertCells() {
        // given
        let sectionIndex = 0
        
        // when
        data.insert = true
        let result = data.update { (updater) in
            updater.diff()
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
    
    func testDiffData_insertSection() {
        // given
        
        // when
        data.insertSection = true
        let result = data.update { (updater) in
            updater.diff()
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
    
    func testDiffData_multiple() {
        // given
        
        // when
        data.insertSection = true
        data.deleted = true
        data.insert = true
        let result = data.update { (updater) in
            updater.diff()
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
    
    func testDiffData_missingSectionUID() {
        #if arch(x86_64) || arch(i386)
        // given
        
        // when
        data.sections.append( TestSectionDescriptor() )
            
        // then
            let exception = NSException.catchException {
            let _ = data.update { (updater) in
                updater.diff()
            }
        }
        XCTAssertNotNil(exception)
        XCTAssertEqual(exception?.name, NSExceptionName.collorMissingSectionUID)
        #endif
    }
    
    func testDiffData_duplicatesSectionsUID() {
        #if arch(x86_64) || arch(i386)
            // given
            
            // when
            data.sections.append( TestSectionDescriptor().uid("section") )
            data.sections.append( TestSectionDescriptor().uid("section") )
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorDuplicateSectionUID)
        #endif
    }
    
    func testDiffData_missingItemUID() {
        #if arch(x86_64) || arch(i386)
            // given
            let cellOne = TestCellDescriptor(adapter: TestAdapter() )
            
            // when
            data.sections[0].reloadSection { cells in
                cells.append( cellOne )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorMissingItemUID)
        #endif
    }
    
    func testDiffData_duplicateItemsUID() {
        #if arch(x86_64) || arch(i386)
            // given
            let cellOne = TestCellDescriptor(adapter: TestAdapter() ).uid("cell0")
            let cellTwo = TestCellDescriptor(adapter: TestAdapter() ).uid("cell0")
            
            // when
            data.sections[0].reloadSection { cells in
                cells.append( cellOne )
                cells.append( cellTwo )
            }
            
            // then
            let exception = NSException.catchException {
                let _ = data.update { (updater) in
                    updater.diff()
                }
            }
            XCTAssertNotNil(exception)
            XCTAssertEqual(exception?.name, NSExceptionName.collorDuplicateItemUID)
        #endif
    }
    
}
