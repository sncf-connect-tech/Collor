//
//  UserEventDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/03/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

final class UserEventDescriptor: CollectionCellDescribable {
    
    let identifier: String = "UserEventCollectionViewCell"
    let className: String = "UserEventCollectionViewCell"
    var selectable:Bool = false
    
    let adapter: UserEventAdapter
    
    init() {
        adapter = UserEventAdapter()
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
