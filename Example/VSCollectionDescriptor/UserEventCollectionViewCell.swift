//
//  UserEventCollectionViewCell.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 14/03/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import VSCollectionDescriptor
import UIKit

class UserEventCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    weak var delegate:UserEventDelegate?
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? UserEventAdapter else {
            fatalError("UserEventAdapter required")
        }
        
        button.setTitle(adapter.titleButton, for: .normal)
    }
    
    func set(delegate: CollectionUserEventDelegate) {
        self.delegate = delegate as? UserEventDelegate
    }
    
    @IBAction func onButtonTap(_ sender: Any) {
        delegate?.onUserEvent(.buttonTap, cell: self)
    }

}
