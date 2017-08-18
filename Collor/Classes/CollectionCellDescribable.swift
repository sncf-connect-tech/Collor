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

public protocol CollectionCellDescribable : class, Identifiable {
    var identifier: String { get }
    var className: String { get }
    var selectable: Bool { get }
    func getAdapter() -> CollectionAdapter
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize
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
