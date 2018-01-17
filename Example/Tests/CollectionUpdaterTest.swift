//
//  CollectionUpdaterTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 03/05/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest
import Collor
import UIKit

struct TestAdapter:CollectionAdapter {
    
}

final class TestSectionDescriptor:CollectionSectionDescribable {
    func sectionInset(_ collectionViewBounds:CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func minimumInteritemSpacing(_ collectionViewBounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat {
        return 5
    }
    func minimumLineSpacing(_ collectionViewBounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat {
        return 5
    }
}

final class SimpleTestSectionDescriptor:CollectionSectionDescribable {
    func sectionInset(_ collectionViewBounds: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

}


final class TestCellDescriptor:CollectionCellDescribable {
    
    
    var identifier: String = "TestCollectionViewCell"
    var className: String = "TestCollectionViewCell"
    var selectable: Bool = false
    var adapter: CollectionAdapter
    
    init(adapter:TestAdapter) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
}

final class TestData:CollectionData {
    override func reloadData() {
        super.reloadData()
        
        let sectionOne = TestSectionDescriptor()
        sectionOne.reloadSection { cells in
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))

        }
        sections.append(sectionOne)
        
        let sectionTwo = SimpleTestSectionDescriptor()
        sectionTwo.reloadSection { cells in
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))
            cells.append( TestCellDescriptor(adapter: TestAdapter() ))
        }
        
        sections.append(sectionTwo)
    }
}

class CollectionUpdaterTest: XCTestCase {
    
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
    
    func testAppendCellsAfterCell() {
        
        // given
        let cellOne = TestCellDescriptor(adapter: TestAdapter() )
        let cellTwo = TestCellDescriptor(adapter: TestAdapter() )
        let sectionIndex = 0
        
        // when
        let result = data.update { (updater) in
            updater.append(cells: [cellOne,cellTwo], after: data.sections[sectionIndex].cells[1])
        }
        
        // then
        XCTAssertTrue(result.deletedCellDescriptors.isEmpty)
        XCTAssertTrue(result.deletedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedCellDescriptors.count, 2)
        XCTAssertTrue(result.insertedCellDescriptors[0] === cellOne)
        XCTAssertTrue(result.insertedCellDescriptors[1] === cellTwo)
        XCTAssertEqual(result.insertedIndexPaths,[ IndexPath(item: 2, section: sectionIndex), IndexPath(item: 3, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 5 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
        XCTAssertEqual(data.sections[sectionIndex].cells[4].indexPath, IndexPath(item: 4, section: sectionIndex) )
    }
    
    func testAppendCellsBeforeCell() {
        
        // given
        let cellOne = TestCellDescriptor(adapter: TestAdapter() )
        let cellTwo = TestCellDescriptor(adapter: TestAdapter() )
        let sectionIndex = 0
        
        // when
        let result = data.update { (updater) in
            updater.append(cells: [cellOne,cellTwo], before: data.sections[sectionIndex].cells[1])
        }
        
        // then
        XCTAssertTrue(result.deletedCellDescriptors.isEmpty)
        XCTAssertTrue(result.deletedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedCellDescriptors.count, 2)
        XCTAssertTrue(result.insertedCellDescriptors[0] === cellOne)
        XCTAssertTrue(result.insertedCellDescriptors[1] === cellTwo)
        XCTAssertEqual(result.insertedIndexPaths,[ IndexPath(item: 1, section: sectionIndex), IndexPath(item: 2, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 5 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
        XCTAssertEqual(data.sections[sectionIndex].cells[4].indexPath, IndexPath(item: 4, section: sectionIndex) )
    }
    
    func testAppendCellsInSection() {
        // given
        let cellOne = TestCellDescriptor(adapter: TestAdapter() )
        let cellTwo = TestCellDescriptor(adapter: TestAdapter() )
        let sectionIndex = 1
        
        // when
        let result = data.update { (updater) in
            updater.append(cells: [cellOne,cellTwo], in: data.sections[sectionIndex])
        }
        
        // then
        XCTAssertTrue(result.deletedCellDescriptors.isEmpty)
        XCTAssertTrue(result.deletedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedCellDescriptors.count, 2)
        XCTAssertTrue(result.insertedCellDescriptors[0] === cellOne)
        XCTAssertTrue(result.insertedCellDescriptors[1] === cellTwo)
        XCTAssertEqual(result.insertedIndexPaths,[ IndexPath(item: 3, section: sectionIndex), IndexPath(item: 4, section: sectionIndex) ])
        
        XCTAssertEqual(data.sections[sectionIndex].cells.count, 5 )
        XCTAssertEqual(data.sections[sectionIndex].cells[0].indexPath, IndexPath(item: 0, section: sectionIndex) )
        XCTAssertEqual(data.sections[sectionIndex].cells[1].indexPath, IndexPath(item: 1, section: sectionIndex) )
    }
    
    func testRemoveCells() {
        // given
        let sectionIndex = 0
        let cellOne = data.sections[sectionIndex].cells[0]
        let cellTwo = data.sections[sectionIndex].cells[1]
        
        
        // when
        let result = data.update { (updater) in
            updater.remove(cells: [cellOne,cellTwo])
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

    func testReloadCells() {
        // given
        let sectionIndex = 0
        let cellOne = data.sections[sectionIndex].cells[1]
        let cellTwo = data.sections[sectionIndex].cells[2]

        // when
        let result = data.update { updater in
            updater.reload(cells: [cellOne, cellTwo])
        }

        XCTAssertTrue(result.insertedCellDescriptors.isEmpty)
        XCTAssertTrue(result.insertedIndexPaths.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)

        XCTAssertEqual(result.reloadedCellDescriptors.count, 2)
        XCTAssertTrue(result.reloadedCellDescriptors[0] === cellOne)
        XCTAssertTrue(result.reloadedCellDescriptors[1] === cellTwo)
        XCTAssertEqual(result.reloadedIndexPaths,[ IndexPath(item: 1, section: sectionIndex), IndexPath(item: 2, section: sectionIndex) ])
    }

    func testAppendSection() {
        // given
        let section = TestSectionDescriptor()
        section.reloadSection { (cells) in
            cells.append(TestCellDescriptor(adapter: TestAdapter()))
        }

        // when
        let result = data.update { updater in
            updater.append(sections: [section] )
        }

        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)

        XCTAssertEqual(result.insertedSectionDescriptors.count, 1)
        XCTAssertTrue(result.insertedSectionDescriptors[0] === section)
        XCTAssertEqual(result.insertedSectionsIndexSet, IndexSet(integer: 2))
        XCTAssertEqual(data.sections[2].cells[0].indexPath, IndexPath(item: 0, section: 2))
    }

    func testAppendSectionAfterSection() {
        // given
        let sectionOne = TestSectionDescriptor()
        sectionOne.reloadSection { (cells) in
            cells.append(TestCellDescriptor(adapter: TestAdapter()))
        }

        let sectionTwo = TestSectionDescriptor()
        sectionTwo.reloadSection { (cells) in
            cells.append(TestCellDescriptor(adapter: TestAdapter()))
        }

        // when
        let result = data.update { updater in
            updater.append(sections: [sectionOne, sectionTwo], after: data.sections[0])
        }

        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)

        XCTAssertEqual(result.insertedSectionDescriptors.count, 2)
        XCTAssertTrue(result.insertedSectionDescriptors[0] === sectionOne)
        XCTAssertTrue(result.insertedSectionDescriptors[1] === sectionTwo)
        XCTAssertTrue(data.sections[1] === sectionOne)
        XCTAssertTrue(data.sections[2] === sectionTwo)
        XCTAssertEqual(result.insertedSectionsIndexSet, IndexSet(arrayLiteral: 1,2))
        XCTAssertEqual(data.sections[1].cells[0].indexPath, IndexPath(item: 0, section: 1))
        XCTAssertEqual(data.sections[3].cells[1].indexPath, IndexPath(item: 1, section: 3))
    }
    
    func testAppendSectionBeforeSection() {
        // given
        let sectionOne = TestSectionDescriptor()
        sectionOne.reloadSection { (cells) in
            cells.append(TestCellDescriptor(adapter: TestAdapter()))
        }
        
        let sectionTwo = TestSectionDescriptor()
        sectionTwo.reloadSection { (cells) in
            cells.append(TestCellDescriptor(adapter: TestAdapter()))
        }
        
        // when
        let result = data.update { updater in
            updater.append(sections: [sectionOne, sectionTwo], before: data.sections[0])
        }
        
        // then
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.insertedSectionDescriptors.count, 2)
        XCTAssertTrue(result.insertedSectionDescriptors[0] === sectionOne)
        XCTAssertTrue(result.insertedSectionDescriptors[1] === sectionTwo)
        XCTAssertTrue(data.sections[0] === sectionOne)
        XCTAssertTrue(data.sections[1] === sectionTwo)
        XCTAssertEqual(result.insertedSectionsIndexSet, IndexSet(arrayLiteral: 0,1))
        XCTAssertEqual(data.sections[2].cells[0].indexPath, IndexPath(item: 0, section: 2))
        XCTAssertEqual(data.sections[3].cells[1].indexPath, IndexPath(item: 1, section: 3))
    }
    
    func testRemoveSection() {
        // given
        let section = data.sections[1]
        
        // when
        let result = data.update { updater in
            updater.remove(sections: [section])
        }
        
        // then
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.reloadedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.reloadedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.deletedSectionDescriptors.count, 1)
        XCTAssertTrue(result.deletedSectionDescriptors[0] === section)
        XCTAssertEqual(result.deletedSectionsIndexSet, IndexSet(integer: 1))
        
        XCTAssertEqual(data.sections.count, 1)
        XCTAssertEqual(data.sections[0].cells[0].indexPath, IndexPath(item: 0, section: 0))
    }
    
    func testReloadSections() {
        // given
        let section = data.sections[1]
        
        // when
        let result = data.update { updater in
            updater.reload(sections: [section])
        }
        
        // then
        XCTAssertTrue(result.insertedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.insertedSectionsIndexSet.isEmpty)
        XCTAssertTrue(result.deletedSectionDescriptors.isEmpty)
        XCTAssertTrue(result.deletedSectionsIndexSet.isEmpty)
        
        XCTAssertEqual(result.reloadedSectionDescriptors.count, 1)
        XCTAssertTrue(result.reloadedSectionDescriptors[0] === section)
        XCTAssertEqual(result.reloadedSectionsIndexSet, IndexSet(integer: 1))
        
        XCTAssertEqual(data.sections[1].cells[0].indexPath, IndexPath(item: 0, section: 1))
    }
}
