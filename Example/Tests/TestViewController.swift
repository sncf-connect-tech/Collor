//
//  TestViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 11/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor
import XCTest

class TestViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let data = TestData()
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: nil)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: nil)
    
    var expectation:XCTestExpectation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(collectionView: collectionView, with: data, and: collectionViewDelegate, and: collectionViewDatasource)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testPerformUpdates()
    }
    
    func testPerformUpdates() {
        // given
        let cellToAppendOne = TestCellDescriptor(adapter: TestAdapter() )
        let cellToAppendTwo = TestCellDescriptor(adapter: TestAdapter() )
        let sectionIndexToAppendCells = 0
        
        let cellToRemove = data.sections[1].cells[0]
        
        let sectionToAppend = TestSectionDescriptor()
        sectionToAppend.cells.append(TestCellDescriptor(adapter: TestAdapter()))
        
        // when
        let result = data.update { (updater) in
            updater.append(cells: [cellToAppendOne,cellToAppendTwo], before: data.sections[sectionIndexToAppendCells].cells[0])
            updater.remove(cells: [cellToRemove])
            updater.append(sections: [sectionToAppend])
        }
        
        self.collectionView.performUpdates(with: result) { ok in
            self.expectation?.fulfill()
        }
    }
}
