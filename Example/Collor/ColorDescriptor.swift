//
//  ColorDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

final class ColorDescriptor: CollectionCellDescribable {
    
    let identifier: String = "ColorCollectionViewCell"
    let className: String = "ColorCollectionViewCell"
    var selectable:Bool = true
    
    let adapter: ColorAdapter
    
    init(adapter: ColorAdapter) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:50)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
