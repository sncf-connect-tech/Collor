//
//  WeatherLabelCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

final class WeatherLabelCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? WeatherLabelAdapterProtocol else {
            fatalError("WeatherLabelAdapterProtocol required")
        }
        label.attributedText = adapter.label
    }

}

final class WeatherLabelDescriptor: CollectionCellDescribable {
    
    let identifier: String = "WeatherLabelCollectionViewCell"
    let className: String = "WeatherLabelCollectionViewCell"
    var selectable:Bool = false
    
    let adapter: WeatherLabelAdapterProtocol
    
    init(adapter:WeatherLabelAdapterProtocol) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:adapter.height ?? adapter.label.height(width))
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}

protocol WeatherLabelAdapterProtocol : CollectionAdapter {
    var label:NSAttributedString { get }
    var height:CGFloat? { get }
}

extension NSAttributedString {
    func height(_ forWidth: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: forWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading],
                                     context: nil)
        return ceil(size.height)
    }
}
