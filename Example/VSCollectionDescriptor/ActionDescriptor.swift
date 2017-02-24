//
//  ActionDescriptor.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 23/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

class ActionDescriptor: VSCollectionCellDescriptor {
    
    let identifier: String = "ActionCollectionViewCell"
    let className: String = "ActionCollectionViewCell"
    var selectable:Bool = true
    var indexPath: IndexPath!
    
    var adapter: VSCollectionAdapter {
        return _adapter
    }
    let _adapter: ActionAdapter
    
    init(action:DemoDatas.Action) {
        _adapter = ActionAdapter(action:action)
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: VSCollectionSectionDescriptor) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:44)
    }
}
