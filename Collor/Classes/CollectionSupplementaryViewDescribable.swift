//
//  CollectionSupplementaryViewDescribable.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//

import Foundation

import Foundation
import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var IndexPath = "collor_SupplementaryViewIndexPath"
}

public protocol CollectionSupplementaryViewDescribable : Identifiable {
    var identifier: String { get }
    var className: String { get }
    func getAdapter() -> CollectionAdapter
    /**
     Return frame according the section - origin of section is the origin of the first cell
    */
    func frame(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGRect
    var bundle: Bundle { get }
}

extension CollectionSupplementaryViewDescribable {
    public internal(set) var indexPath: IndexPath? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndexPath) as? IndexPath
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.IndexPath, newValue as IndexPath?, .OBJC_ASSOCIATION_COPY)
        }
    }
}

public extension CollectionSupplementaryViewDescribable {
    var bundle: Bundle {
        let typeClass = type(of: self)
        return Bundle(for: typeClass)
    }
}
