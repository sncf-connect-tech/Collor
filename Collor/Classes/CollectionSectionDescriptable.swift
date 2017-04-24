//
//  CollectionSectionDescribable.swift
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

public protocol CollectionSectionDescribable : class {
    var cells: [CollectionCellDescribable] { get set}
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView) -> Int
}

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView) -> Int {
        return 10
    }
}

extension CollectionSectionDescribable {
    public var index: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionIndex) as! Int
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionIndex, newValue as Int, .OBJC_ASSOCIATION_COPY)
        }
    }
}
