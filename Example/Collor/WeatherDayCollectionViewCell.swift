//
//  WeatherDayCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor
import AlamofireImage

final class WeatherDayCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.af_cancelImageRequest()
        imageView.image = nil
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? WeatherDayAdapter else {
            fatalError("WeatherDayAdapter required")
        }
        imageView.af_setImage(withURL: adapter.iconURL)
        label.attributedText = adapter.date
    }
}

final class WeatherDayDescriptor: CollectionCellDescribable {
    
    let identifier: String = "WeatherDayCollectionViewCell"
    let className: String = "WeatherDayCollectionViewCell"
    var selectable:Bool = true
    
    let adapter: WeatherDayAdapter
    
    init(adapter:WeatherDayAdapter) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:60)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
