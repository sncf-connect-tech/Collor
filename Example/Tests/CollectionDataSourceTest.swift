//
//  CollorTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 03/05/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest
@testable import Collor
import UIKit

class CollectionDataSourceTest: XCTestCase {
    
    var collectionView:UICollectionView!
    var collectionDataSource:CollectionDataSource!
    var collectionDelegate:CollectionDelegate!
    var data:TestData!
    
    override func setUp() {
        super.setUp()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        
        data = TestData()
        collectionDataSource = CollectionDataSource(delegate: nil)
        collectionDelegate = CollectionDelegate(delegate: nil)
        
        bind(collectionView: collectionView, with: data, and: collectionDelegate, and: collectionDataSource)
        
        data.computeIndices()
        collectionView.reloadData()
    }
    
    func testSectionsCount() {
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 2)
        XCTAssertEqual(collectionView.dataSource!.numberOfSections!(in: collectionView), 2)
        
        collectionDataSource.collectionData = nil
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 0)
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 0)
    }
    
    func testNumberOfItems() {
        XCTAssertEqual(collectionDataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        
        collectionDataSource.collectionData = nil
        XCTAssertEqual(collectionDataSource.collectionView(collectionView, numberOfItemsInSection: 0), 0)
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 0)
    }
    
    func testCellForItem() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        let cellClassName = "TestCollectionViewCell"
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        
        var type = Swift.type(of: collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
        XCTAssertEqual(String(describing: type), cellClassName)
        XCTAssertTrue(collectionDataSource.collectionData!.registeredCells.contains(cellClassName))
        
        // no adaptable
        let descriptor = data.cellDescribable(at: indexPath) as! TestCellDescriptor
        descriptor.className = "NoAdaptableCollectionViewCell"
        descriptor.identifier = "NoAdaptableCollectionViewCell"
        type = Swift.type(of: collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
        XCTAssertEqual(String(describing: type), "UICollectionViewCell")
        
        // nibless using automatic CFBundleName
        let niblessAutomaticDescriptor = data.cellDescribable(at: indexPath) as! TestCellDescriptor
        niblessAutomaticDescriptor.className = "NiblessCollectionViewCell"
        niblessAutomaticDescriptor.identifier = "NiblessAutomaticCollectionViewCell"
        type = Swift.type(of: collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
        XCTAssertEqual(String(describing: type), "NiblessCollectionViewCell")
        
        // nibless using fully qualified class name
        let niblessQualifiedDescriptor = data.cellDescribable(at: indexPath) as! TestCellDescriptor
        niblessQualifiedDescriptor.className = "\(bundleName).NiblessCollectionViewCell"
        niblessQualifiedDescriptor.identifier = "NiblessQualifiedCollectionViewCell"
        type = Swift.type(of: collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
        XCTAssertEqual(String(describing: type), "NiblessCollectionViewCell")
        
        // collectionDatas nil
        collectionDataSource.collectionData = nil
        type = Swift.type(of: collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
        XCTAssertEqual(String(describing: type), "UICollectionViewCell")
    }
    
    var expectation:XCTestExpectation?
    
//    func testPerformUpdates() {
//        // given
//        let cellToAppendOne = TestCellDescriptor(adapter: TestAdapter() )
//        let cellToAppendTwo = TestCellDescriptor(adapter: TestAdapter() )
//        let sectionIndexToAppendCells = 0
//        
//        let cellToRemove = data.sections[1].cells[0]
//        
//        let sectionToAppend = TestSectionDescriptor()
//        sectionToAppend.cells.append(TestCellDescriptor(adapter: TestAdapter()))
//        
//        expectation = expectation(description: "performUpdates")
//        
//        // when
//        let result = data.update { (updater) in
//            updater.append(cells: [cellToAppendOne,cellToAppendTwo], before: data.sections[sectionIndexToAppendCells].cells[0])
//            updater.remove(cells: [cellToRemove])
//            updater.append(sections: [sectionToAppend])
//        }
//        
//        //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//        
//            self.collectionView.performUpdates(with: result) { (done) in
//                XCTAssertEqual(self.collectionView.dataSource?.numberOfSections!(in: self.collectionView), 3)
//                //            // append 2 cells in section 0
//                //            XCTAssertEqual(self.collectionView.dataSource?.collectionView(self.collectionView, numberOfItemsInSection: 0), 5)
//                //            // remove 1 cells in section 1
//                //            XCTAssertEqual(self.collectionView.dataSource?.collectionView(self.collectionView, numberOfItemsInSection: 1), 2)
//            }
//            
//        }
//        
//        
//        
//        // then
//        waitForExpectations(timeout: 2.0) { (error) in
//            XCTAssertNotNil(error)
//            // append section
//            XCTAssertEqual(self.collectionView.dataSource?.numberOfSections!(in: self.collectionView), 3)
//            // append 2 cells in section 0
//            XCTAssertEqual(self.collectionView.dataSource?.collectionView(self.collectionView, numberOfItemsInSection: 0), 5)
//            // remove 1 cells in section 1
//            XCTAssertEqual(self.collectionView.dataSource?.collectionView(self.collectionView, numberOfItemsInSection: 1), 2)
//        }
//    }

    
    override func tearDown() {
        super.tearDown()
    }
    
}
