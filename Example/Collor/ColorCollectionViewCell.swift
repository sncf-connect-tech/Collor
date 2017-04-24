//
//  ColorCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? ColorAdapter else {
            fatalError("ColorAdapter required")
        }
        
        backgroundColor = adapter.color

    }

}
