//
//  TitleDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

final class TitleDescriptor: CollectionCellDescribable {
    
    let identifier: String = "TitleCollectionViewCell"
    let className: String = "TitleCollectionViewCell"
    var selectable:Bool = true
    
    let adapter: TitleAdapter
    
    init(adapter:TitleAdapter) {
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
