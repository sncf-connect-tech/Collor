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
            self.insertItems(at: result.insertedIndexPaths)
            self.deleteItems(at: result.deletedIndexPaths)
            self.reloadItems(at: result.reloadedIndexPaths)
            self.insertSections(result.insertedSectionsIndexSet)
            self.deleteSections(result.deletedSectionsIndexSet)
            self.reloadSections(result.reloadedSectionsIndexSet)
            result.movedIndexPaths.forEach { (from,to) in
                self.moveItem(at: from, to: to)
            }
        }, completion: completion)
    }
}
