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
    static var SectionIndex = "collor_SectionIndex"
}

public protocol CollectionSectionDescribable : class, Identifiable {
    var cells: [CollectionCellDescribable] { get set}
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
}

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumLineSpacing
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
