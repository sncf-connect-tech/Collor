//
//  CollectionSectionDescriptable.swift
//  Pods
//
//  Created by Guihal Gwenn on 16/03/17.
//
//

import Foundation
import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var SectionIndex = "vs_SectionIndex"
}

public protocol CollectionSectionDescriptable : class {
    var cells: [CollectionCellDescriptable] { get set}
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView) -> Int
}

// default implementation CollectionSectionDescriptable
public extension CollectionSectionDescriptable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView) -> Int {
        return 10
    }
}

extension CollectionSectionDescriptable {
    public var index: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionIndex) as! Int
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionIndex, newValue as Int, .OBJC_ASSOCIATION_COPY)
        }
    }
}

func ==(lhs: CollectionSectionDescriptable, rhs: CollectionSectionDescriptable) -> Bool {
    return lhs.index == rhs.index
}

func !=(lhs: CollectionSectionDescriptable, rhs: CollectionSectionDescriptable) -> Bool {
    return lhs.index != rhs.index
}
