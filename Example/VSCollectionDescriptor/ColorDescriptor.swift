//
//  ColorDescriptor.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

class ColorDescriptor: VSCollectionCellDescriptor {
    
    let identifier: String = "ColorCollectionViewCell"
    let className: String = "ColorCollectionViewCell"
    var selectable:Bool = false
    var indexPath: IndexPath!
    
    var adapter: VSCollectionAdapter {
        return _adapter
    }
    let _adapter: ColorAdapter
    
    init(hexaColor:Int) {
        _adapter = ColorAdapter(hexaColor:hexaColor)
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: VSCollectionSectionDescriptor) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:50)
    }
}
