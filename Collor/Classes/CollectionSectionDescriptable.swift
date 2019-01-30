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
    static var SectionBuilderSupp = "collor_SectionBuilderSupp"
    static var SectionCells = "collor_SectionCells"
    static var SectionSupplementaryViews = "collor_SectionSupplementaryViews"
}

public protocol CollectionSectionDescribable : Identifiable {
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat    
}

public typealias SectionBuilderClosure = (inout [CollectionCellDescribable]) -> Void
public typealias SectionBuilderObjectClosure = (SectionBuilder) -> Void

public class SectionBuilder {
    public var cells: [CollectionCellDescribable] = []
    public internal(set) var supplementaryViews: [String:[CollectionSupplementaryViewDescribable]] = [:]
    
    public func add(supplementaryView: CollectionSupplementaryViewDescribable, kind: String) {
        if var viewsForKind = supplementaryViews[kind] {
            viewsForKind.append(supplementaryView)
            supplementaryViews[kind] = viewsForKind
        } else {
            supplementaryViews[kind] = [supplementaryView]
        }
    }
}

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumLineSpacing
    }
    
    @discardableResult func reloadSection(_ builderClosure:@escaping (inout [CollectionCellDescribable]) -> Void) -> Self {
        self.builder = builderClosure
        cells.removeAll()
        supplementaryViews.removeAll()
        builderClosure(&cells)
        return self
    }
    
    @discardableResult func reload(_ builder:@escaping (SectionBuilder) -> Void) -> Self {
        self.builderObject = builder
        cells.removeAll()
        supplementaryViews.removeAll()
        let builderObject = SectionBuilder()
        builder(builderObject)
        cells = builderObject.cells
        supplementaryViews = builderObject.supplementaryViews
        return self
    }
}

public extension CollectionSectionDescribable {
    func uid(for cell:CollectionCellDescribable) -> String? {
        guard let sectionUID = _uid, let cellUID = cell._uid else {
            return nil
        }
        return "\(sectionUID)/\(cellUID)"
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
    
    var builderObject: SectionBuilderObjectClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionBuilderSupp) as? SectionBuilderObjectClosure
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionBuilderSupp, newValue as SectionBuilderObjectClosure?, .OBJC_ASSOCIATION_COPY)
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
    
    public internal(set) var supplementaryViews: [String:[CollectionSupplementaryViewDescribable]] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionSupplementaryViews) as? [String:[CollectionSupplementaryViewDescribable]] ?? [String:[CollectionSupplementaryViewDescribable]]()
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionSupplementaryViews, newValue as [String:[CollectionSupplementaryViewDescribable]], .OBJC_ASSOCIATION_COPY)
        }
    }
}
