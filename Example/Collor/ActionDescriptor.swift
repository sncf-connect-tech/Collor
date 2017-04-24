//
//  ActionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 23/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

final class ActionDescriptor: CollectionCellDescribable {
    
    let identifier: String = "ActionCollectionViewCell"
    let className: String = "ActionCollectionViewCell"
    var selectable:Bool = true
    
    let adapter: ActionAdapter
    
    init(adapter:ActionAdapter) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:44)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }

}
