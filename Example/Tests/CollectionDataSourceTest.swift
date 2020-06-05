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
    
    var collectionView: UICollectionView!
    var collectionDataSource: CollectionDataSource!
    var collectionDelegate: CollectionDelegate!
    var data: TestData!
    
    override func setUp() {
        super.setUp()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        
        data = TestData()
        collectionDataSource = CollectionDataSource(delegate: nil)
        collectionDelegate = CollectionDelegate(delegate: nil)
        collectionView.collectionViewLayout = TestLayout(datas: data)
        
        bind(collectionView: collectionView, with: data, and: collectionDelegate, and: collectionDataSource)
        
        data.computeIndices()
        collectionView.collectionViewLayout.prepare()
        collectionView.reloadData()
    }
    
    func testSectionsCount() {
        XCTAssertEqual(collectionDataSource.numberOfSections(in: collectionView), 3)
        XCTAssertEqual(collectionView.dataSource!.numberOfSections!(in: collectionView), 3)
        
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
    
    func testViewForSupplementaryElementOfKind() {
        // given
        let indexPath = IndexPath(item: 0, section: 2)
        let cellClassName = "TestReusableView"
        
        let type = Swift.type(of: collectionDataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: "test", at: indexPath))
        XCTAssertEqual(String(describing: type), cellClassName)
        XCTAssertTrue(collectionDataSource.collectionData!.registeredSupplementaryViews.contains(cellClassName))
    }
    
    func testViewForSupplementaryElementOfKind_2() {
        // given
        let indexPath = IndexPath(item: 1, section: 2)
        let cellClassName = "TestReusableView"
        
        let type = Swift.type(of: collectionDataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: "test", at: indexPath))
        XCTAssertEqual(String(describing: type), cellClassName)
        XCTAssertTrue(collectionDataSource.collectionData!.registeredSupplementaryViews.contains(cellClassName))
    }
}
