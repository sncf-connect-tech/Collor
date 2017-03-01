//
//  TitleDescriptor.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

class TitleDescriptor: CollectionCellDescriptable {
    
    let identifier: String = "TitleCollectionViewCell"
    let className: String = "TitleCollectionViewCell"
    var selectable:Bool = true
    var indexPath: IndexPath!
    
    var adapter: CollectionAdapter {
        return _adapter
    }
    let _adapter: TitleAdapter
    
    init(color:DemoDatas.Color) {
        _adapter = TitleAdapter(color: color)
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescriptable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:50)
    }
}
