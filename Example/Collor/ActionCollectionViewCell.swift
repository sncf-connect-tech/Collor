//
//  ActionCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 23/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import UIKit

class ActionCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? ActionAdapter else {
            fatalError("ActionAdapter required")
        }
        actionLabel.text = adapter.actionName

    }

}
