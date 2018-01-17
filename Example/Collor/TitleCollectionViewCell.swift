//
//  TitleCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor

final class TitleCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    
    var descriptor: CollectionCellDescribable?
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? TitleAdapterProtocol else {
            fatalError("TitleAdapterProtocol required")
        }
        titleLabel.attributedText = adapter.title
        leftLineView.backgroundColor = adapter.lineColor
        rightLineView.backgroundColor = adapter.lineColor
    }

}

final class TitleDescriptor: CollectionCellDescribable {
    
    let identifier: String = "TitleCollectionViewCell"
    let className: String = "TitleCollectionViewCell"
    var selectable:Bool = false    
    var adapter: CollectionAdapter
    
    init(adapter:TitleAdapterProtocol) {
        self.adapter = adapter
    }
    
    func size(_ bounds:CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        guard let adapter = adapter as? TitleAdapterProtocol else {
            fatalError("TitleAdapterProtocol required")
        }
        let sectionInset = sectionDescriptor.sectionInset(bounds)
        let width:CGFloat = bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:adapter.cellHeight)
    }
}

protocol TitleAdapterProtocol : CollectionAdapter {
    var title:NSAttributedString { get }
    var lineColor:UIColor { get }
    var cellHeight:CGFloat { get }
}
