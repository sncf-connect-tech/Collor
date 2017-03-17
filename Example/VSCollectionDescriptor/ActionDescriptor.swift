//
//  ActionDescriptor.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 23/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

class ActionDescriptor: CollectionCellDescriptable {
    
    let identifier: String = "ActionCollectionViewCell"
    let className: String = "ActionCollectionViewCell"
    var selectable:Bool = true
    
    var adapter: CollectionAdapter {
        return _adapter
    }
    let _adapter: ActionAdapter
    
    init(action:DemoDatas.Action) {
        _adapter = ActionAdapter(action:action)
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescriptable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:44)
    }
}
