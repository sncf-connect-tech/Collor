//
//  TestViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 11/05/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor
import XCTest

class TestViewController: UIViewController {
    
    enum State {
        case simple
        case diff
        case diffSection
    }
    
    let state:State
    
    init(state:State) {
        self.state = state
        
        switch state {
        case .simple:
            data = TestData()
        case .diff:
            data = DiffTestData()
        case .diffSection:
            data = DiffSectionTestData()
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let data:CollectionData
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
        case .diff:
            testPerformUpdatesDiff()
        case .diffSection:
            testPerformUpdatesDiffSection()
        }
    }
    
    func testPerformUpdates() {
        // given
        let cellToAppendOne = TestCellDescriptor(adapter: TestAdapter() )
        let cellToAppendTwo = TestCellDescriptor(adapter: TestAdapter() )
        let sectionIndexToAppendCells = 0
        
        let cellToRemove = data.sections[1].cells[0]
        
        let sectionToAppend = TestSectionDescriptor()
        sectionToAppend.reloadSection { cells in
            cells.append( TestCellDescriptor(adapter: TestAdapter()) )
        }
        
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
    
    func testPerformUpdatesDiff() {
        // given
        (data as! DiffTestData).insert = true
        (data as! DiffTestData).insertSection = true
        (data as! DiffTestData).deleted = true
        
        // when
        let result = data.update { (updater) in
            updater.diff()
        }
        
        self.collectionView.performUpdates(with: result) { ok in
            self.expectation?.fulfill()
        }
    }
    
    func testPerformUpdatesDiffSection() {
        // given
        (data as! DiffSectionTestData).insert = true
        (data as! DiffSectionTestData).deleted = true
        
        // when
        let result = data.update { (updater) in
            updater.diff(sections: data.sections)
        }
        
        self.collectionView.performUpdates(with: result) { ok in
            self.expectation?.fulfill()
        }
    }

}
