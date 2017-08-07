//
//  TitleCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

final class TitleCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
    
    let adapter: TitleAdapterProtocol
    
    init(adapter:TitleAdapterProtocol) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:adapter.cellHeight)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}

protocol TitleAdapterProtocol : CollectionAdapter {
    var title:NSAttributedString { get }
    var lineColor:UIColor { get }
    var cellHeight:CGFloat { get }
}
