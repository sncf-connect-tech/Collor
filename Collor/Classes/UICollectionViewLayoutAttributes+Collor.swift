//
//  UICollectionViewLayoutAttributes+Collor.swift
//  Pods
//
//  Created by Guihal Gwenn on 01/09/2017.
//
//

import Foundation
import UIKit

extension UICollectionViewLayoutAttributes : Identifiable {
    
}

extension UICollectionViewLayoutAttributes : Diffable {
    public func isEqual(to other: Diffable?) -> Bool {
        guard let other = other as? UICollectionViewLayoutAttributes else {
            return false
        }
        return self == other
    }
}
