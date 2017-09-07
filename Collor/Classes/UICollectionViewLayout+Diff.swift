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
}

public extension UICollectionViewLayout {
    public func diff(oldDecorationAttributes:DecorationAttributes, newDecorationAttributes:DecorationAttributes) -> DecorationDiff {
        
        var insertedDecorationIndexPaths = [String:[IndexPath]]()
        var deletedDecorationIndexPaths = [String:[IndexPath]]()
        
        let elementKindKinds = Set(newDecorationAttributes.flatMap{$0.key} + oldDecorationAttributes.flatMap{$0.key})
        elementKindKinds.forEach { elementKind in
            
            insertedDecorationIndexPaths[elementKind] = [IndexPath]()
            deletedDecorationIndexPaths[elementKind] = [IndexPath]()
            
            let old = map(attributes: oldDecorationAttributes[elementKind])
            let new = map(attributes: newDecorationAttributes[elementKind])
            
            print(elementKind)
            print("old",old)
            print("new",new)
            
            var diff = CollorDiff(before: old, after: new)
            
            let same = Set(diff.inserted).intersection(diff.deleted)
            print("same",same)
            same.forEach {
                if newDecorationAttributes[elementKind]![$0] == oldDecorationAttributes[elementKind]![$0] {
                    diff.inserted.remove(at: diff.inserted.index(of: $0)!)
                    diff.deleted.remove(at: diff.deleted.index(of: $0)!)
                }
            }
            
            print("same",same)
            
            diff.inserted.forEach {
                insertedDecorationIndexPaths[elementKind]!.append($0)
            }
            diff.deleted.forEach {
                deletedDecorationIndexPaths[elementKind]!.append($0)
            }
        }
        return DecorationDiff(inserted: insertedDecorationIndexPaths, deleted: deletedDecorationIndexPaths)
    }
    
    private func map(attributes:[IndexPath : UICollectionViewLayoutAttributes]?) -> [(IndexPath,String)] {
        return attributes?.map{ ($0.value.indexPath,$0.value.uid()!) }.sorted(by: { $0.0.0 < $0.1.0 }) ?? [(IndexPath,String)]()
    }
}
