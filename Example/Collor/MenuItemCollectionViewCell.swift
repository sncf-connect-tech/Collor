//
//  MenuItemCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor

final class MenuItemCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    var adapter:MenuItemAdapter?
    var userEventDelegate:MenuUserEventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //example for user Event
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuItemCollectionViewCell.onTap(gr:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onTap(gr:UIGestureRecognizer) {
        guard let adapter = adapter, let delegate = userEventDelegate else {
            return
        }
        delegate.onUserEvent(userEvent: .itemTap(adapter.example))
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? MenuItemAdapter else {
            fatalError("MenuItemAdapter required")
        }
        self.adapter = adapter
        
        label.text = adapter.label
    }
    
    func set(delegate: CollectionUserEventDelegate?) {
        userEventDelegate = delegate as? MenuUserEventDelegate
    }

}

final class MenuItemDescriptor: CollectionCellDescribable {
    
    let identifier: String = "MenuItemCollectionViewCell"
    let className: String = "MenuItemCollectionViewCell"
    var selectable:Bool = false
    var adapter: CollectionAdapter
    
    init(adapter:MenuItemAdapter) {
        self.adapter = adapter
    }
    
    func size(_ bounds:CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(bounds)
        let width:CGFloat = bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:55)
    }
}
