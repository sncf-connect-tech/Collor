//
//  UICollectionView+CollectionDescriptor.swift
//  Pods
//
//  Created by Guihal Gwenn on 14/03/17.
//
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
        }, completion: completion)
    }
}
