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
    
    enum State {
        case simple
        case reload
    }
    
    let state:State
    
    init(state:State) {
        self.state = state
        
        switch state {
        case .simple:
            data = TestData()
        case .reload:
            data = ReloadTestData()
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let data:CollectionDatas
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: nil)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: nil)
    
    var expectation:XCTestExpectation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(collectionView: collectionView, with: data, and: collectionViewDelegate, and: collectionViewDatasource)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch state {
        case .simple:
            testPerformUpdates()
        case .reload:
            testPerformUpdatesReloadData()
        }
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
    
    func testPerformUpdatesReloadData() {
        // given
        (data as! ReloadTestData).insert = true
        (data as! ReloadTestData).insertSection = true
        (data as! ReloadTestData).deleted = true
        
        // when
        let result = data.update { (updater) in
            updater.reloadData()
        }
        
        self.collectionView.performUpdates(with: result) { ok in
            self.expectation?.fulfill()
        }
    }

}
