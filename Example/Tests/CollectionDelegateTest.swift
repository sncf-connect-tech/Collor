//
//  CollectionDelegateTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 10/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor
import UIKit

class CollectionDelegateTest: XCTestCase {
    
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
    
    func testShouldSelectItem() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        
        // selectable false
        XCTAssertFalse(collectionDelegate.collectionView(collectionView, shouldSelectItemAt: indexPath))
        
        // selectable true
        let descriptor = data.cellDescribable(at: indexPath) as! TestCellDescriptor
        descriptor.selectable = true
        XCTAssertTrue(collectionDelegate.collectionView(collectionView, shouldSelectItemAt: indexPath))
        
        collectionDelegate.collectionDatas = nil
        XCTAssertFalse(collectionDelegate.collectionView(collectionView, shouldSelectItemAt: indexPath))
    }
    
    var expectation:XCTestExpectation?
    
    func testDidSelectItem() {
        
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        expectation = expectation(description: "didSelect")
        collectionDelegate.delegate = self
        
        // when
        collectionDelegate.collectionView(collectionView, didSelectItemAt: indexPath)
        
        // then
        waitForExpectations(timeout: 1.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testFlowLayoutSizeForItem() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        // when
        let size = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
        // then
        XCTAssertEqual(size, CGSize(width: 0, height: 50))
    }
    
    func testFlowLayoutSizeForItem_collectionDatasNil() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        collectionDelegate.collectionDatas = nil
        // when
        let size = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
        // then
        XCTAssertEqual(size, CGSize.zero)
    }
    
    func testInsetForSection() {
        // given
        let section = 0
        // when
        let inset = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: section)
        // then
        XCTAssertEqual(inset, UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func testInsetForSection_collectionDatasNil() {
        // given
        let section = 0
        collectionDelegate.collectionDatas = nil
        // when
        let inset = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: section)
        // then
        XCTAssertEqual(inset, UIEdgeInsets.zero)
    }
    
    func testMinimumInteritemSpacingForSection() {
        // given
        let section = 0
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 5)
    }
    
    func testMinimumInteritemSpacingForSection_default() {
        // given
        let section = 1
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 10)
    }
    
    func testMinimumInteritemSpacingForSection_collectionDatasNil() {
        // given
        let section = 0
        collectionDelegate.collectionDatas = nil
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 10)
    }
    
    func testMinimumInteritemSpacingForSection_noFlowLayout() {
        // given
        let section = 0
        collectionView.collectionViewLayout = UICollectionViewLayout()
        collectionDelegate.collectionDatas = nil
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 0)
    }
    
    func testMinimumLineSpacingForSection() {
        // given
        let section = 0
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 5)
    }
    
    func testMinimumLineSpacingForSection_default() {
        // given
        let section = 1
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 10)
    }
    
    func testMinimumLineSpacingForSection_collectionDatasNil() {
        // given
        let section = 0
        collectionDelegate.collectionDatas = nil
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 10)
    }
    
    func testMinimumLineSpacingForSection_noFlowLayout() {
        // given
        let section = 0
        collectionView.collectionViewLayout = UICollectionViewLayout()
        collectionDelegate.collectionDatas = nil
        // when
        let spacing = collectionDelegate.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: section)
        // then
        XCTAssertEqual(spacing, 0)
    }
}

extension CollectionDelegateTest : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {
        expectation?.fulfill()
    }
}
