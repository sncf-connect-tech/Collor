//
//  ActionCollectionViewCell.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 23/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import UIKit

class ActionCollectionViewCell: UICollectionViewCell, VSCollectionCellProtocol {

    @IBOutlet weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithAdapter(adapter aAdapter: VSCollectionAdapter) -> Void {
        guard let adapter = aAdapter as? ActionAdapter else {
            fatalError("ActionAdapter required")
        }
        actionLabel.text = adapter.actionName

    }

}
