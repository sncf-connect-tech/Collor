//
//  LabelCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor

final class LabelCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? LabelAdapterProtocol else {
            fatalError("LabelAdapterProtocol required")
        }
        label.attributedText = adapter.label
    }

}

final class LabelDescriptor: CollectionCellDescribable {
    
    let identifier: String = "LabelCollectionViewCell"
    let className: String = "LabelCollectionViewCell"
    var selectable:Bool = true
    var adapter: CollectionAdapter
    
    init(adapter:LabelAdapterProtocol) {
        self.adapter = adapter
    }
    
    func size(_ bounds:CGRect, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        guard let adapter = adapter as? LabelAdapterProtocol else {
            fatalError("LabelAdapterProtocol required")
        }
        let sectionInset = sectionDescriptor.sectionInset(bounds)
        let width:CGFloat = adapter.width ?? bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:adapter.height ?? adapter.label.height(width))
    }
}

protocol LabelAdapterProtocol : CollectionAdapter {
    var label:NSAttributedString { get }
    var height:CGFloat? { get }
    var width:CGFloat? { get }
}

extension NSAttributedString {
    func height(_ forWidth: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: forWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                     context: nil)
        return ceil(size.height)
    }
}
