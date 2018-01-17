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

private struct AssociatedKeys {
    static var IndexPath = "collor_IndexPath"
}

public protocol CollectionCellDescribable : Identifiable {
    var identifier: String { get }
    var className: String { get }
    var selectable: Bool { get }
    var adapter: CollectionAdapter { get }
    func size(_ bounds: CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize
}

public extension CollectionCellDescribable {
    func size(_ bounds: CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(bounds)
        let width = bounds.width - sectionInset.left - sectionInset.right
        // Estimated height ItemSize so 1 for height
        return CGSize(width: width, height: 1)
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

