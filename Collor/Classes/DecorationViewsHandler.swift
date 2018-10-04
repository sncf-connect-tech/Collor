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
    
    public mutating func add(attributes:UICollectionViewLayoutAttributes) {
        guard let elementKind = attributes.representedElementKind else {
            return
        }
        _attributes[elementKind]![attributes.indexPath] = attributes
    }
    
    public mutating func prepare() {
        _oldAttributes = _attributes
        _elementKinds.forEach { elementKind in
            _attributes[elementKind]?.removeAll()
        }
    }
    
    
    
    public func attributes(in rect:CGRect) -> [UICollectionViewLayoutAttributes] {
        return _attributes.flatMap { $0.value }.map { $0.value }.filter { $0.frame.intersects(rect) }
    }
    
    public func attributes(for elementKind:String) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return attributes(for: elementKind, into: _attributes)
    }
    
    public func attributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath) -> T? {
        return attributes(for: elementKind, at: indexPath, into: _attributes)
    }
    
    public func oldAttributes(for elementKind:String) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return attributes(for: elementKind, into: _oldAttributes)
    }
    
    public func oldAttributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath) -> T? {
        return attributes(for: elementKind, at: indexPath, into: _oldAttributes)
    }
    
    public mutating func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        _elementKinds.forEach { elementKind in
            _inserted[elementKind] = [IndexPath]()
            _deleted[elementKind] = [IndexPath]()
        }
        
        updateItems.forEach { updateItem in
            switch (updateItem.updateAction) {
            case .delete:
                guard let indexPathBeforeUpdate = updateItem.indexPathBeforeUpdate else {
                    break
                }
                elementKind(for: indexPathBeforeUpdate, in: _oldAttributes!).forEach { kind in
                    _deleted[kind]!.append(indexPathBeforeUpdate)
                }
            case .insert:
                guard let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                    break
                }
                elementKind(for: indexPathAfterUpdate, in: _attributes).forEach { kind in
                    _inserted[kind]!.append(indexPathAfterUpdate)
                }
            case .reload, .move: //TODO: if move, try to check if same kind of decorationView doesn't impact the move
                guard let indexPathBeforeUpdate = updateItem.indexPathBeforeUpdate,
                    let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                    break
                }
                elementKind(for: indexPathBeforeUpdate, in: _oldAttributes!).forEach { kind in
                    _deleted[kind]!.append(indexPathBeforeUpdate)
                }
                elementKind(for: indexPathAfterUpdate, in: _attributes).forEach { kind in
                    _inserted[kind]!.append(indexPathAfterUpdate)
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

extension DecorationViewsHandler {
    func elementKind(for indexPath:IndexPath, in decorationAttributes:DecorationAttributes) -> [String] {
        
        var elementKinds = [String]()
        
        decorationAttributes.forEach { (elementKind, values) in
            if values.keys.contains(indexPath) {
                elementKinds.append(elementKind)
            }
        }
        return elementKinds
    }
    
    func attributes(for elementKind:String, into decorationAttributes:DecorationAttributes?) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return decorationAttributes?[elementKind] ?? [IndexPath : UICollectionViewLayoutAttributes]()
    }
    
    func attributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath, into decorationAttributes:DecorationAttributes?) -> T? {
        return decorationAttributes?[elementKind]?[indexPath] as? T
    }
}
