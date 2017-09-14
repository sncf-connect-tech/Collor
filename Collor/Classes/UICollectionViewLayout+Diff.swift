//
//  UICollectionViewLayout+Diff.swift
//  Pods
//
//  Created by Guihal Gwenn on 07/09/2017.
//
//

import Foundation
import UIKit

public typealias DecorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]

public struct DecorationDiff {
    public let inserted: [String:[IndexPath]]
    public let deleted: [String:[IndexPath]]
    public init(inserted: [String:[IndexPath]], deleted: [String:[IndexPath]]) {
        self.inserted = inserted
        self.deleted = deleted
    }
}

public extension UICollectionViewLayout {
    public func diff(oldDecorationAttributes:DecorationAttributes, newDecorationAttributes:DecorationAttributes) -> DecorationDiff {
        
        var insertedDecorationIndexPaths = [String:[IndexPath]]()
        var deletedDecorationIndexPaths = [String:[IndexPath]]()
        
        let elementKindKinds = newDecorationAttributes.map{ $0.key }
        elementKindKinds.forEach { elementKind in
            
            insertedDecorationIndexPaths[elementKind] = [IndexPath]()
            deletedDecorationIndexPaths[elementKind] = [IndexPath]()
            
            let old = map(attributes: oldDecorationAttributes[elementKind]!)
            let new = map(attributes: newDecorationAttributes[elementKind]!)
            
            let diff = CollorDiff(before: old, after: new)
            
            diff.inserted.forEach {
                insertedDecorationIndexPaths[elementKind]!.append($0)
            }
            diff.deleted.forEach {
                deletedDecorationIndexPaths[elementKind]!.append($0)
            }
        }
        return DecorationDiff(inserted: insertedDecorationIndexPaths, deleted: deletedDecorationIndexPaths)
    }
    
    private func map(attributes:[IndexPath : UICollectionViewLayoutAttributes]) -> [CollorDiff<IndexPath, String>.DiffItem] {
        
        return attributes.map {
            (index: $0.value.indexPath, key: $0.value.uid()!, value: $0.value)
        }.sorted(by: {
            $0.0.index < $0.1.index
        })
    }
}
