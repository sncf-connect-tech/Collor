//
//  CollectionCellDescribable.swift
//  Collor
//
//  Created by Guihal Gwenn on 16/03/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC


public enum LayoutFittingPriority {
    case width
    case height
    case both
}

public protocol CollectionCellLayoutFitting {
    var layoutPriority:LayoutFittingPriority { get }
}

private struct AssociatedKeys {
    static var IndexPath = "collor_IndexPath"
}

public protocol CollectionCellDescribable : Identifiable {
    var identifier: String { get }
    var className: String { get }
    var selectable: Bool { get }
    var adapter: CollectionAdapter { get }
    func size(_ collectionViewBounds: CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize
}

public extension CollectionCellDescribable {
    func size(_ collectionViewBounds: CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionViewBounds)
        let width = collectionViewBounds.width - sectionInset.left - sectionInset.right
        let height = collectionViewBounds.height - sectionInset.top - sectionInset.bottom
        // Estimated height ItemSize so 1 for height
        return CGSize(width: width, height: height)
    }
    func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
extension CollectionCellDescribable {
    public internal(set) var indexPath: IndexPath? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndexPath) as? IndexPath
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.IndexPath, newValue as IndexPath?, .OBJC_ASSOCIATION_COPY)
        }
    }
}

