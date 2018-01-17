//
//  UICollectionView+CollectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/03/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import UIKit
import Foundation

extension UICollectionView {
    public func performUpdates(with result: UpdateCollectionResult, completion: ((Bool) -> Void)? = nil) {
        self.performBatchUpdates({
            self.insertSections(result.insertedSectionsIndexSet)
            self.deleteSections(result.deletedSectionsIndexSet)
            self.reloadSections(result.reloadedSectionsIndexSet)
            self.insertItems(at: result.insertedIndexPaths)
            self.deleteItems(at: result.deletedIndexPaths)
            self.reloadItems(at: result.reloadedIndexPaths)
            result.movedIndexPaths.forEach { (from,to) in
                self.moveItem(at: from, to: to)
            }
        }, completion: completion)
    }
}


struct FittingPriority {
    var horizontal: UILayoutPriority
    var vertical: UILayoutPriority
}

extension UICollectionViewCell  {
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)
        guard let cell = self as? CollectionCellAdaptable, let descriptor = cell.descriptor as? CollectionCellLayoutFitting else { return attribute }
        var priority:FittingPriority
        switch descriptor.layoutPriority {
        case .both:
            priority = FittingPriority(horizontal: .fittingSizeLevel, vertical: .fittingSizeLevel)
        case .height:
            priority = FittingPriority(horizontal: .required, vertical: .fittingSizeLevel)
        case .width:
            priority = FittingPriority(horizontal: .fittingSizeLevel, vertical: .required)
        }
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size,
                                                       withHorizontalFittingPriority: priority.horizontal,
                                                       verticalFittingPriority: priority.vertical)
        attribute.frame.size = size
        return attribute
    }
}
