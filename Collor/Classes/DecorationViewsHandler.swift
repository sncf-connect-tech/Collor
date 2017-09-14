//
//  DecorationViewsHandler.swift
//  Pods
//
//  Created by Guihal Gwenn on 07/09/2017.
//
//

import Foundation
import UIKit
import CoreGraphics

public typealias DecorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]

public struct DecorationDiff {
    public let inserted: [String:[IndexPath]]
    public let deleted: [String:[IndexPath]]
    public init(inserted: [String:[IndexPath]], deleted: [String:[IndexPath]]) {
        self.inserted = inserted
        self.deleted = deleted
    }
}

public struct DecorationViewsHandler {
    
    unowned let _collectionViewLayout: UICollectionViewLayout
    var _elementKinds = [String]()
    var _attributes = DecorationAttributes()
    var _oldAttributes:DecorationAttributes?
    
    // update
    var _inserted = [String : [IndexPath]]()
    var _deleted = [String : [IndexPath]]()
    
    public init(collectionViewLayout: UICollectionViewLayout) {
        _collectionViewLayout = collectionViewLayout
    }
    
    public mutating func register(viewClass:AnyClass, for elementKind:String) {
        if let _ = _attributes[elementKind] {
            return
        }
        _elementKinds.append(elementKind)
        _attributes[elementKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        _collectionViewLayout.register(viewClass, forDecorationViewOfKind: elementKind)
    }
    
    public mutating func register(nib:UINib, for elementKind:String) {
        if let _ = _attributes[elementKind] {
            return
        }
        _elementKinds.append(elementKind)
        _attributes[elementKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        _collectionViewLayout.register(nib, forDecorationViewOfKind: elementKind)
    }
    
    public mutating func prepare() {
        _oldAttributes = _attributes
        _elementKinds.forEach { elementKind in
            _attributes[elementKind]?.removeAll()
        }
    }
    
    public mutating func add(attributes:UICollectionViewLayoutAttributes, for elementKind:String, at indexPath:IndexPath) {
        _attributes[elementKind]![indexPath] = attributes
    }
    
    public func attributes(in rect:CGRect) -> [UICollectionViewLayoutAttributes] {
        return _attributes.flatMap { $0.value }.map { $0.value }.filter { $0.frame.intersects(rect) }
    }
    
    public func attributes(for elementKind:String) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return _attributes[elementKind] ?? [IndexPath : UICollectionViewLayoutAttributes]()
    }
    
    public func attributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath) -> T? {
        return _attributes[elementKind]?[indexPath] as? T
    }
    
    public func oldAttributes(for elementKind:String) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return _oldAttributes?[elementKind] ?? [IndexPath : UICollectionViewLayoutAttributes]()
    }
    
    public func oldAttributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath) -> T? {
        return _oldAttributes?[elementKind]?[indexPath] as? T
    }
    
    func elementKind(for indexPath:IndexPath, in decorationAttributes:DecorationAttributes) -> [String] {
        
        var elementKinds = [String]()
        
        decorationAttributes.forEach { (elementKind, values) in
            if values.keys.contains(indexPath) {
                elementKinds.append(elementKind)
            }
        }
        return elementKinds
    }
    
    public mutating func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        _elementKinds.forEach { elementKind in
            _inserted[elementKind] = [IndexPath]()
            _deleted[elementKind] = [IndexPath]()
        }
        
        updateItems.forEach { updateItem in
            switch (updateItem.updateAction) {
            case .delete:
                elementKind(for: updateItem.indexPathBeforeUpdate!, in: _oldAttributes!).forEach { kind in
                    _deleted[kind]!.append(updateItem.indexPathBeforeUpdate!)
                }
            case .insert:
                elementKind(for: updateItem.indexPathAfterUpdate!, in: _attributes).forEach { kind in
                    _inserted[kind]!.append(updateItem.indexPathAfterUpdate!)
                }
            case .reload:
                elementKind(for: updateItem.indexPathBeforeUpdate!, in: _oldAttributes!).forEach { kind in
                    _deleted[kind]!.append(updateItem.indexPathBeforeUpdate!)
                }
                elementKind(for: updateItem.indexPathAfterUpdate!, in: _attributes).forEach { kind in
                    _inserted[kind]!.append(updateItem.indexPathAfterUpdate!)
                }
            default:
                break
            }
        }
    }
    
    public func inserted(for elementKind:String) -> [IndexPath] {
        return _inserted[elementKind] ?? []
    }
    
    public func deleted(for elementKind:String) -> [IndexPath] {
        return _deleted[elementKind] ?? []
    }
}
