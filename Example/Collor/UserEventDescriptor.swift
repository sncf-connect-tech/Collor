//
//  UserEventDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/03/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

class UserEventDescriptor: CollectionCellDescriptable {
    
    let identifier: String = "UserEventCollectionViewCell"
    let className: String = "UserEventCollectionViewCell"
    var selectable:Bool = false
    
    var adapter: CollectionAdapter {
        return _adapter
    }
    let _adapter: UserEventAdapter
    
    init() {
        _adapter = UserEventAdapter()
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescriptable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:44)
    }
}
