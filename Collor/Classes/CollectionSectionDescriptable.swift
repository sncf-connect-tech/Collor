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

public protocol CollectionSectionDescribable : Identifiable {
    func sectionInset(_ bounds:CGRect) -> UIEdgeInsets
    func minimumInteritemSpacing(_ bounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat
    func minimumLineSpacing(_ bounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat
}

public extension CollectionSectionDescribable {
    func ipadInsetX(_ bounds:CGRect) -> CGFloat {
        let maxiPhoneWidth: CGFloat = 414 // iPhone Plus width
        return UIDevice.current.userInterfaceIdiom == .pad ? (bounds.width - maxiPhoneWidth) * 0.5 : 0;
    }
}

public typealias SectionBuilderClosure = (inout [CollectionCellDescribable]) -> Void

// default implementation CollectionSectionDescribable
public extension CollectionSectionDescribable {
    func minimumInteritemSpacing(_ bounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumInteritemSpacing
    }
    func minimumLineSpacing(_ bounds:CGRect, layout: UICollectionViewFlowLayout) -> CGFloat {
        return layout.minimumLineSpacing
    }
    
    @discardableResult func reloadSection(_ builder:@escaping SectionBuilderClosure) -> Self {
        self.builder = builder
        cells.removeAll()
        builder(&cells)
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
    
    public internal(set) var cells: [CollectionCellDescribable] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.SectionCells) as? [CollectionCellDescribable] ?? [CollectionCellDescribable]()
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.SectionCells, newValue as [CollectionCellDescribable], .OBJC_ASSOCIATION_COPY)
        }
    }
}
