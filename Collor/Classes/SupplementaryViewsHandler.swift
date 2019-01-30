//
//  SupplementaryViewsHandler.swift
//  Pods
//
//  Created by Guihal Gwenn on 07/09/2017.
//
//

import Foundation
import UIKit
import CoreGraphics

public typealias SupplementaryAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]

public struct SupplementaryViewsHandler {
    
    unowned let _collectionViewLayout: UICollectionViewLayout
    var _elementKinds = [String]()
    var _attributes = SupplementaryAttributes()
    var _oldAttributes: SupplementaryAttributes?
    
    // update
    var _inserted = [String : [IndexPath]]()
    var _deleted = [String : [IndexPath]]()
    
    public init(collectionViewLayout: UICollectionViewLayout) {
        _collectionViewLayout = collectionViewLayout
    }
    
    public mutating func add(attributes:UICollectionViewLayoutAttributes) {
        guard let elementKind = attributes.representedElementKind else {
            return
        }
        if !_elementKinds.contains(elementKind) {
            _elementKinds.append(elementKind)
        }
        if var kindAttributes = _attributes[elementKind] {
            kindAttributes[attributes.indexPath] = attributes
            _attributes[elementKind] = kindAttributes
        } else {
            _attributes[elementKind] = [attributes.indexPath: attributes]
        }
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
                    if indexPathBeforeUpdate.item == Int.max {
                        
                        let indexPaths = self.attributes(for: kind, into: self._oldAttributes)
                            .values
                            .filter{ $0.indexPath.section ==  indexPathBeforeUpdate.section}
                            .map { $0.indexPath }
                        
                        _deleted[kind]!.append(contentsOf: indexPaths)
                    } else {
                        _deleted[kind]!.append(indexPathBeforeUpdate)
                    }
                }
            case .insert:
                guard let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                    break
                }
                elementKind(for: indexPathAfterUpdate, in: _attributes).forEach { kind in
                    if indexPathAfterUpdate.isSectionOnly {
                        let indexPaths = self.attributes(for: kind, into: self._attributes)
                            .values
                            .filter{ $0.indexPath.section ==  indexPathAfterUpdate.section}
                            .map { $0.indexPath }
                        _inserted[kind]!.append(contentsOf: indexPaths)
                    } else {
                        _inserted[kind]!.append(indexPathAfterUpdate)
                    }
                }
            case .reload, .move: //TODO: if move, try to check if same kind of supplementaryViewsView doesn't impact the move
                guard let indexPathBeforeUpdate = updateItem.indexPathBeforeUpdate,
                    let indexPathAfterUpdate = updateItem.indexPathAfterUpdate else {
                    break
                }
                elementKind(for: indexPathBeforeUpdate, in: _oldAttributes!).forEach { kind in
                    if indexPathBeforeUpdate.isSectionOnly {
                        
                        let indexPaths = self.attributes(for: kind, into: self._oldAttributes)
                            .values
                            .filter{ $0.indexPath.section ==  indexPathBeforeUpdate.section}
                            .map { $0.indexPath }
                        
                        _deleted[kind]!.append(contentsOf: indexPaths)
                    } else {
                        _deleted[kind]!.append(indexPathBeforeUpdate)
                    }
                }
                elementKind(for: indexPathAfterUpdate, in: _attributes).forEach { kind in
                    if indexPathAfterUpdate.isSectionOnly {
                        let indexPaths = self.attributes(for: kind, into: self._attributes)
                            .values
                            .filter{ $0.indexPath.section ==  indexPathAfterUpdate.section}
                            .map { $0.indexPath }
                        _inserted[kind]!.append(contentsOf: indexPaths)
                    } else {
                        _inserted[kind]!.append(indexPathAfterUpdate)
                    }
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

extension SupplementaryViewsHandler {
    func elementKind(for indexPath: IndexPath, in supplementaryViewsAttributes: SupplementaryAttributes) -> [String] {
        
        // section
        if indexPath.isSectionOnly {
            return supplementaryViewsAttributes
                .filter { $0.value.keys.contains(where: { $0.section == indexPath.section }) }
                .map { $0.key }
        // item
        } else {
            return supplementaryViewsAttributes
                .filter { $0.value.keys.contains(indexPath) }
                .map { $0.key }
        }
    }
    
    func attributes(for elementKind:String, into supplementaryViewsAttributes: SupplementaryAttributes?) -> [IndexPath : UICollectionViewLayoutAttributes] {
        return supplementaryViewsAttributes?[elementKind] ?? [IndexPath : UICollectionViewLayoutAttributes]()
    }
    
    func attributes<T:UICollectionViewLayoutAttributes>(for elementKind:String, at indexPath:IndexPath, into supplementaryViewsAttributes: SupplementaryAttributes?) -> T? {
        return supplementaryViewsAttributes?[elementKind]?[indexPath] as? T
    }
}

extension IndexPath {
    var isSectionOnly: Bool {
        return self.item == Int.max
    }
}
