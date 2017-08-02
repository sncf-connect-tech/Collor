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
    static var SectionBuilder = "collor_SectionBuilder"
    static var SectionCells = "collor_SectionCells"
}

public protocol CollectionSectionDescribable : class, Identifiable {
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
    
    //func reloadSection(updates: ()->Void )
}

public typealias BuilderClosure = (inout [CollectionCellDescribable]) -> Void

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumLineSpacing
    }
    
    func build(_ builder:@escaping BuilderClosure) {
        self.builder = builder
        cells.removeAll()
        builder(&cells)
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
    var builder: BuilderClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionBuilder) as? BuilderClosure
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionBuilder, newValue as BuilderClosure?, .OBJC_ASSOCIATION_COPY)
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
