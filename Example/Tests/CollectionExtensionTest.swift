//
//  CollectionExtensionTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 15/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor

class CollectionExtensionTest: XCTestCase {
    
    func testIndexNil() {
        let array = ["A","B"]
        XCTAssertNil(array[safe:nil])
    }
    
}
