//
//  TitleCollectionViewCell.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import UIKit

class TitleCollectionViewCell: UICollectionViewCell, VSCollectionCellProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithAdapter(adapter aAdapter: VSCollectionAdapter) -> Void {
        guard let adapter = aAdapter as? TitleAdapter else {
            fatalError("TitleAdapter required")
        }

        titleLabel.text = adapter.title
        
    }

}
