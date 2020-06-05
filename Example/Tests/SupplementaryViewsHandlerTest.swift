//
//  SupplementaryViewHandlerTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 10/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor

class SupplementaryViewHandlerTest: XCTestCase {
    
    var controller:TestViewController!
    
    override func setUp() {
        super.setUp()
        
        controller = TestViewController(state: .simple)
        let navigationController = UINavigationController(rootViewController: controller)
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        XCTAssertNotNil(controller.view)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddAttributes() {
        // given
        let elementKind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: IndexPath(item: 0, section: 0))
        // when
        handler.add(attributes: attributes)
        XCTAssertEqual(handler._attributes[elementKind]!.count,1)
        XCTAssertEqual(handler._attributes[elementKind]!.first!.key,IndexPath(item: 0, section: 0))
        XCTAssertEqual(handler._attributes[elementKind]!.first?.value,attributes)
    }
    
    func testAddAttributes_notConform() {
        // given
        let elementKind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes()
        // when
        handler.add(attributes: attributes)
        XCTAssertNil(handler._attributes[elementKind])
    }
    
    func testAddAttributes_notConform_decoration() {
        // given
        let elementKind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: IndexPath())
        // when
        handler.add(attributes: attributes)
        XCTAssertNil(handler._attributes[elementKind])
    }


    func testPrepare() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        XCTAssertEqual(handler._attributes["testKind"]!.count,1)
        // when
        handler.prepare()
        // then
        XCTAssertEqual(handler._oldAttributes!["testKind"]!.count,1)

        XCTAssertTrue(handler._attributes["testKind"]!.isEmpty)
    }

    func testAttributesInRect() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 0, width: 320, height: 150)
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(in: CGRect(x: 0, y: 0, width: 320, height: 568))
        // then
        XCTAssertEqual(result, [attributes])
    }

    func testAttributesInRect_Empty() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 600, width: 320, height: 150)
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(in: CGRect(x: 0, y: 0, width: 320, height: 568))
        // then
        XCTAssertEqual(result, [])
    }

    func testAttributesForElementKind() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "testKind")
        // then
        XCTAssertEqual(result.count,1)
        XCTAssertEqual(result.keys.first!, IndexPath(item: 0, section: 0))
        XCTAssertEqual(result.values.first!, attributes)
    }

    func testOldAttributesForElementKind() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        handler.prepare()
        let result = handler.oldAttributes(for: "testKind")
        // then
        XCTAssertEqual(result.count,1)
        XCTAssertEqual(result.keys.first!, IndexPath(item: 0, section: 0))
        XCTAssertEqual(result.values.first!, attributes)
    }

    func testAttributesForElementKind_Empty() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "noExist")
        // then
        XCTAssertEqual(result.count,0)
    }

    func testAttributes() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = TestCollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result:TestCollectionViewLayoutAttributes? = handler.attributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertEqual(result,attributes)
    }

    func testOldAttributes() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = TestCollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        handler.prepare()
        let result:TestCollectionViewLayoutAttributes? = handler.oldAttributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertEqual(result,attributes)
    }

    func testAttributes_wrongType() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result:TestCollectionViewLayoutAttributes? = handler.attributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertNil(result)
    }

    func testAttributes_wrongKind() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "wrongKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertNil(result)
    }

    func testAttributes_wrongIndexPath() {
        // given
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "testKind", at: IndexPath(item: 2, section: 0))
        // then
        XCTAssertNil(result)
    }

    func testPrepareUpdate_Delete() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 0, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()

        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .delete, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)

        // then
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
        XCTAssertEqual(handler.deleted(for: kind).count, 1)
        XCTAssertEqual(handler.deleted(for: kind).first!, indexPath)
    }
    
    func testPrepareUpdate_Delete_invalid() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 0, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .delete, indexPathBeforeUpdate: nil, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_Delete_sectionOnly() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: Int.max, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .delete, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
        XCTAssertEqual(handler.deleted(for: kind).count, 1)
        XCTAssertEqual(handler.deleted(for: kind).first!, indexPath)
    }
    
    func testPrepareUpdate_None() {
        // given
        let kind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.prepare()
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .none, indexPathBeforeUpdate: nil, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }

    func testPrepareUpdate_Insert() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 1, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.prepare()
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)

        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .insert, indexPathBeforeUpdate: nil, indexPathAfterUpdate: indexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)

        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertEqual(handler.inserted(for: kind).count, 1)
        XCTAssertEqual(handler.inserted(for: kind).first!, indexPath)
    }
    
    func testPrepareUpdate_Insert_invalid() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 1, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.prepare()
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .insert, indexPathBeforeUpdate: nil, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_Insert_sectionOnly() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: Int.max, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.prepare()
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .insert, indexPathBeforeUpdate: nil, indexPathAfterUpdate: indexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertEqual(handler.inserted(for: kind).count, 1)
        XCTAssertEqual(handler.inserted(for: kind).first!, indexPath)
    }

    func testPrepareUpdate_Reload() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 0, section: 0)
        let newindexPath = IndexPath(item: 1, section: 0)
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: newindexPath)
        handler.add(attributes: newAttributes)


        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .reload, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)

        // then
        XCTAssertEqual(handler.deleted(for: kind).count, 1)
        XCTAssertEqual(handler.deleted(for: kind).first!, indexPath)
        XCTAssertEqual(handler.inserted(for: kind).count, 1)
        XCTAssertEqual(handler.inserted(for: kind).first!, newindexPath)
    }

    func testPrepareUpdate_Move() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        let newindexPath = IndexPath(item: 1, section: 0)
        let kind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: newindexPath)
        handler.add(attributes: newAttributes)

        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .move, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)

        // then
        XCTAssertEqual(handler.deleted(for: kind).count, 1)
        XCTAssertEqual(handler.deleted(for: kind).first!, indexPath)
        XCTAssertEqual(handler.inserted(for: kind).count, 1)
        XCTAssertEqual(handler.inserted(for: kind).first!, newindexPath)
    }
    
    func testPrepareUpdate_Move_invalid() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        let newindexPath = IndexPath(item: 1, section: 0)
        let kind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: newindexPath)
        handler.add(attributes: newAttributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .move, indexPathBeforeUpdate: nil, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_Move_sectionOnly() {
        // given
        let indexPath = IndexPath(item: Int.max, section: 0)
        let newindexPath = IndexPath(item: Int.max, section: 0)
        let kind = "testKind"
        var handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: newindexPath)
        handler.add(attributes: newAttributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .move, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertEqual(handler.deleted(for: kind).count, 1)
        XCTAssertEqual(handler.deleted(for: kind).first!, indexPath)
        XCTAssertEqual(handler.inserted(for: kind).count, 1)
        XCTAssertEqual(handler.inserted(for: kind).first!, newindexPath)
    }

    func testGetInserted_kindNoExist() {
        // given
        let handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // then
        XCTAssertTrue(handler.inserted(for: "noExist").isEmpty)
    }

    func testGetDeleted_kindNoExist() {
        // given
        let handler = SupplementaryViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // then
        XCTAssertTrue(handler.deleted(for: "noExist").isEmpty)
    }
}
