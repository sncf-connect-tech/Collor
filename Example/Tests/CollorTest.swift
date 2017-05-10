//
//  CollorTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 03/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Collor
import UIKit

class CollorTest: XCTestCase {
    
    var collectionView:UICollectionView!
    var collectionDataSource:CollectionDataSource!
    var collectionDelegate:CollectionDelegate!
    var data:TestData!
    
    override func setUp() {
        super.setUp()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        data = TestData()
        collectionDataSource = CollectionDataSource(delegate: nil)
        collectionDelegate = CollectionDelegate(delegate: nil)
        
        bind(collectionView: collectionView, with: data, and: collectionDelegate, and: collectionDataSource)
        
        collectionView.reloadData()
    }
    
    func testSectionsCount() {
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 2)
        XCTAssertEqual(collectionView.dataSource!.numberOfSections!(in: collectionView), 2)
        
        collectionDataSource.collectionDatas = nil
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 0)
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 0)
    }
    
    func testNumberOfItems() {
        XCTAssertEqual(collectionDataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        
        collectionDataSource.collectionDatas = nil
        XCTAssertEqual(collectionDataSource.collectionView(collectionView, numberOfItemsInSection: 0), 0)
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 0)
    }
    
    func testCellForItem() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        
        XCTAssertNotNil(collectionDataSource.collectionView(collectionView, cellForItemAt: indexPath))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}
