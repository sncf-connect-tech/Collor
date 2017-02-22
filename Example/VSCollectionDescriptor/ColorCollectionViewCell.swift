//
//  ColorCollectionViewCell.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import UIKit

class ColorCollectionViewCell: UICollectionViewCell, VSCollectionCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithAdapter(adapter aAdapter: VSCollectionAdapter) -> Void {
        guard let adapter = aAdapter as? ColorAdapter else {
            fatalError("ColorAdapter required")
        }
        
        backgroundColor = adapter.color

    }

}
