//
//  CollectionSectionDescribable.swift
//  Collor
//
//  Created by Guihal Gwenn on 16/03/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//
//

import Foundation
import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var SectionIndex = "collor_SectionIndex"
    static var SectionBuilder = "collor_SectionBuilder"
    static var SectionCells = "collor_SectionCells"
}

public protocol CollectionSectionDescribable : class, Identifiable {
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat    
}

public typealias SectionBuilderClosure = (inout [CollectionCellDescribable]) -> Void

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumLineSpacing
    }
    
    @discardableResult func reloadSection(_ builder:@escaping SectionBuilderClosure) -> Self {
        self.builder = builder
        cells.removeAll()
        builder(&cells)
        return self
    }
}

extension CollectionSectionDescribable {
    public internal(set) var index: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionIndex) as? Int
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionIndex, newValue as Int?, .OBJC_ASSOCIATION_COPY)
        }
    }
    var builder: SectionBuilderClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionBuilder) as? SectionBuilderClosure
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionBuilder, newValue as SectionBuilderClosure?, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    public internal(set) var cells: [CollectionCellDescribable] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionCells) as? [CollectionCellDescribable] ?? [CollectionCellDescribable]()
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionCells, newValue as [CollectionCellDescribable], .OBJC_ASSOCIATION_COPY)
        }
    }
}
