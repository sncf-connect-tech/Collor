//
//  CollectionViewTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 11/05/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import XCTest

class PerformUpdatesTest: XCTestCase {
    
    var controller:TestViewController!
    
    override func setUp() {
        super.setUp()
    }
    
    
    
    func testPerformUpdates() {
        
        controller = TestViewController(state: .simple)
        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        XCTAssertNotNil(controller.view)
        
        controller.expectation = expectation(description: "testPerformUpdates")
        
        XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 2)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 3)

        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            // append section
            XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 3)
            // append 2 cells in section 0
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 5)
            // remove 1 cells in section 1
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 2)
        }
        
    }
    
    func testPerformUpdatesDiff() {
        
        controller = TestViewController(state: .diff)
        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        XCTAssertNotNil(controller.view)
        
        controller.expectation = expectation(description: "testPerformUpdatesDiff")
        
        XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 2)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 3)
        
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            // append section
            XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 3)
            // append 2 cells in section 0
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 5)
            // remove 2 cells in section 1, which becomes 2
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 1)
        }
        
    }
    
    func testPerformUpdatesDiffSection() {
        
        controller = TestViewController(state: .diffSection)
        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        XCTAssertNotNil(controller.view)
        
        controller.expectation = expectation(description: "testPerformUpdatesDiffSection")
        
        XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 2)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 3)
        
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            // append section
            XCTAssertEqual(self.controller.collectionView.dataSource?.numberOfSections!(in: self.controller.collectionView), 2)
            // append 2 cells in section 0
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 0), 5)
            // remove 2 cells in section 1
            XCTAssertEqual(self.controller.collectionView.dataSource?.collectionView(self.controller.collectionView, numberOfItemsInSection: 1), 1)
        }
        
    }
}
