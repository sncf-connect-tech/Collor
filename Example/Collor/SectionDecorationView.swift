//
//  SectionDecorationView.swift
//
//  Created by Guihal Gwenn on 04/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import CoreGraphics

protocol SectionDecorable {
    var hasBackground:Bool { get }
}

class SectionDecorationViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat?
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! SectionDecorationViewLayoutAttributes
        copy.backgroundColor = backgroundColor
        copy.cornerRadius = cornerRadius
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? SectionDecorationViewLayoutAttributes else {
            return false
        }
        if object.backgroundColor != backgroundColor && object.cornerRadius != cornerRadius {
            return false
        }
        return super.isEqual(object)
    }
    
}

class SectionDecorationView: UICollectionReusableView {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        guard let layoutAttributes = layoutAttributes as? SectionDecorationViewLayoutAttributes else {
            fatalError("SectionDecorationViewLayoutAttributes required")
        }
        
        backgroundColor = layoutAttributes.backgroundColor

        layer.cornerRadius = layoutAttributes.cornerRadius ?? 0
        layer.zPosition = -10 + CGFloat(layoutAttributes.zIndex) // fix issue in zIndex sorting in collectionView on ios10
    }
}
