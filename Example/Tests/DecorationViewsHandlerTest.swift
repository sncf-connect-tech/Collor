//
//  DecorationViewsHandlerTest.swift
//  Collor
//
//  Created by Guihal Gwenn on 18/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import Collor

class DecorationViewHandlerTest: XCTestCase {
    
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
    
    func testRegister() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // when
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        //then
        XCTAssertEqual(handler._attributes.debugDescription, "[\"testKind\": [:]]")
        XCTAssertEqual(handler._elementKinds.debugDescription, "[\"testKind\"]")
    }
    
    func testRegister_kindAlreadyExists() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // when
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        // then
        XCTAssertEqual(handler._attributes.debugDescription, "[\"testKind\": [:]]")
        XCTAssertEqual(handler._elementKinds.debugDescription, "[\"testKind\"]")
    }
    
    func testRegisterNib() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let nib = UINib(nibName: String(describing: TestDecorationView.self), bundle: nil)
        // when
        handler.register(nib: nib, for: "testKind")
        // then
        XCTAssertEqual(handler._attributes.debugDescription, "[\"testKind\": [:]]")
        XCTAssertEqual(handler._elementKinds.debugDescription, "[\"testKind\"]")
    }
    
    func testRegisterNib_kindAlreadyExists() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        let nib = UINib(nibName: String(describing: TestDecorationView.self), bundle: nil)
        // when
        handler.register(nib: nib, for: "testKind")
        handler.register(nib: nib, for: "testKind")
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        // then
        XCTAssertEqual(handler._attributes.debugDescription, "[\"testKind\": [:]]")
        XCTAssertEqual(handler._elementKinds.debugDescription, "[\"testKind\"]")
    }
    
    func testAddAttributes() {
        // given
        let elementKind = "testKind"
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: elementKind)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: IndexPath(item: 0, section: 0))
        // when
        handler.add(attributes: attributes)
        XCTAssertEqual(handler._attributes[elementKind]!.count,1)
        XCTAssertEqual(handler._attributes[elementKind]!.first!.key,IndexPath(item: 0, section: 0))
        XCTAssertEqual(handler._attributes[elementKind]!.first?.value,attributes)
    }
    
    func testAddAttributes_notConform() {
        // given
        let elementKind = "testKind"
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: elementKind)
        let attributes = UICollectionViewLayoutAttributes()
        // when
        handler.add(attributes: attributes)
        XCTAssertTrue(handler._attributes[elementKind]!.isEmpty)
    }

    
    func testPrepare() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        handler.register(viewClass: TestDecorationView.self, for: "test2Kind")
        XCTAssertEqual(handler._attributes.keys.sorted().debugDescription, "[\"test2Kind\", \"testKind\"]")
        XCTAssertEqual(handler._elementKinds.debugDescription, "[\"testKind\", \"test2Kind\"]")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 0, width: 320, height: 150)
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(in: CGRect(x: 0, y: 0, width: 320, height: 568))
        // then
        XCTAssertEqual(result, [attributes])
    }
    
    func testAttributesInRect_Empty() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 600, width: 320, height: 150)
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(in: CGRect(x: 0, y: 0, width: 320, height: 568))
        // then
        XCTAssertEqual(result, [])
    }
    
    func testAttributesForElementKind() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "noExist")
        // then
        XCTAssertEqual(result.count,0)
    }
    
    func testAttributes() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = TestCollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result:TestCollectionViewLayoutAttributes? = handler.attributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertEqual(result,attributes)
    }
    
    func testOldAttributes() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = TestCollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        handler.prepare()
        let result:TestCollectionViewLayoutAttributes? = handler.oldAttributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertEqual(result,attributes)
    }
    
    func testAttributes_wrongType() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result:TestCollectionViewLayoutAttributes? = handler.attributes(for: "testKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertNil(result)
    }
    
    func testAttributes_wrongKind() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
        handler.add(attributes: attributes)
        // when
        let result = handler.attributes(for: "wrongKind", at: IndexPath(item: 0, section: 0))
        // then
        XCTAssertNil(result)
    }
    
    func testAttributes_wrongIndexPath() {
        // given
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: "testKind")
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "testKind", with: IndexPath(item: 0, section: 0))
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
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
    
    func testPrepareUpdate_Insert() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 1, section: 0)
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        handler.prepare()
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        handler.prepare()
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .insert, indexPathBeforeUpdate: nil, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_Reload() {
        // given
        let kind = "testKind"
        let indexPath = IndexPath(item: 0, section: 0)
        let newindexPath = IndexPath(item: 1, section: 0)
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: newindexPath)
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
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        handler.prepare()
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .move, indexPathBeforeUpdate: indexPath, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_Move_invalid() {
        // given
        let indexPath = IndexPath(item: 0, section: 0)
        let newindexPath = IndexPath(item: 1, section: 0)
        let kind = "testKind"
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: indexPath)
        handler.add(attributes: attributes)
        handler.prepare()
        let newAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: kind, with: newindexPath)
        handler.add(attributes: newAttributes)
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .move, indexPathBeforeUpdate: nil, indexPathAfterUpdate: newindexPath)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testPrepareUpdate_None() {
        // given
        let kind = "testKind"
        var handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        handler.register(viewClass: TestDecorationView.self, for: kind)
        handler.prepare()
        
        // when
        let updateItem = TestUICollectionViewUpdateItem(updateAction: .none, indexPathBeforeUpdate: nil, indexPathAfterUpdate: nil)
        let updateItems = [ updateItem ]
        handler.prepare(forCollectionViewUpdates: updateItems)
        
        // then
        XCTAssertTrue(handler.deleted(for: kind).isEmpty)
        XCTAssertTrue(handler.inserted(for: kind).isEmpty)
    }
    
    func testGetInserted_kindNoExist() {
        // given
        let handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // then
        XCTAssertTrue(handler.inserted(for: "noExist").isEmpty)
    }
    
    func testGetDeleted_kindNoExist() {
        // given
        let handler = DecorationViewsHandler(collectionViewLayout: controller.collectionView.collectionViewLayout)
        // then
        XCTAssertTrue(handler.deleted(for: "noExist").isEmpty)
    }
}

class  TestUICollectionViewUpdateItem : UICollectionViewUpdateItem {
    let _updateAction:UICollectionViewUpdateItem.Action
    let _indexPathAfterUpdate: IndexPath?
    let _indexPathBeforeUpdate: IndexPath?
    public init(updateAction:UICollectionViewUpdateItem.Action, indexPathBeforeUpdate:IndexPath?, indexPathAfterUpdate:IndexPath?) {
        _updateAction = updateAction
        _indexPathAfterUpdate = indexPathAfterUpdate
        _indexPathBeforeUpdate = indexPathBeforeUpdate
        
        super.init()
    }
    
    override var updateAction: UICollectionViewUpdateItem.Action {
        return _updateAction
    }
    
    override var indexPathAfterUpdate: IndexPath? {
        return _indexPathAfterUpdate
    }
    
    override var indexPathBeforeUpdate: IndexPath? {
        return _indexPathBeforeUpdate
    }
}
