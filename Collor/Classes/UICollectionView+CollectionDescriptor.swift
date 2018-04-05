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
            let insertedIndexPaths = result.insertedIndexPaths.filter {
                $0.section.notContained(in: result.insertedSectionsIndexSet)
            }
            self.insertItems(at: insertedIndexPaths)
            let deletedIndexPaths = result.deletedIndexPaths.filter {
                $0.section.notContained(in: result.deletedSectionsIndexSet)
            }
            self.deleteItems(at: deletedIndexPaths)
            let reloadedIndexPaths = result.reloadedIndexPaths.filter {
                $0.section.notContained(in: result.reloadedSectionsIndexSet)
            }
            self.reloadItems(at: reloadedIndexPaths)
            result.movedIndexPaths.forEach { (from,to) in
                self.moveItem(at: from, to: to)
            }
        }, completion: completion)
    } 
}

fileprivate extension Equatable {
    func notContained<S: Sequence>(in sequence: S) -> Bool where S.Element == Self {
        return !sequence.contains(self)
    }
}
