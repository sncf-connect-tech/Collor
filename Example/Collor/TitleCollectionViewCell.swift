//
//  TitleCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import UIKit

final class TitleCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? TitleAdapter else {
            fatalError("TitleAdapter required")
        }

        titleLabel.text = adapter.title
        
    }

}
