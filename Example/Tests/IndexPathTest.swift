//
//  IndexPathTest.swift
//  Collor_Tests
//
//  Created by Guihal Gwenn on 13/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor

class IndexPathTest: XCTestCase {

    func test_isSectionOnly_true() {
        // given
        let indexPath = IndexPath(item: Int.max, section: 0)
        // when
        let isSectionOnly = indexPath.isSectionOnly
        // then
        XCTAssertTrue(isSectionOnly)
    }
    
    func test_isSectionOnly_false() {
        // given
        let indexPath = IndexPath(item: 2, section: 0)
        // when
        let isSectionOnly = indexPath.isSectionOnly
        // then
        XCTAssertFalse(isSectionOnly)
    }

}
