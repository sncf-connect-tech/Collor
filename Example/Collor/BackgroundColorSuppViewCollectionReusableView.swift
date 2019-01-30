//
//  BackgroundColorSuppViewCollectionReusableView.swift
//  Collor_Example
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class BackgroundColorSuppViewDescriptor : CollectionSupplementaryViewDescribable {
    var identifier: String = "BackgroundColorSuppViewCollectionReusableView"
    var className: String = "BackgroundColorSuppViewCollectionReusableView"
    
    let adapter: BackgroundColorSuppViewAdapter
    
    init(adapter: BackgroundColorSuppViewAdapter) {
        self.adapter = adapter
    }
    
    func getAdapter() -> CollectionAdapter {
        return adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
}

struct BackgroundColorSuppViewAdapter: CollectionAdapter {
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
}

class BackgroundColorSuppViewCollectionReusableView: UICollectionReusableView, CollectionSupplementaryViewAdaptable {
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? BackgroundColorSuppViewAdapter else {
            fatalError("BackgroundColorSuppViewAdapter required")
        }
        self.backgroundColor = adapter.color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
