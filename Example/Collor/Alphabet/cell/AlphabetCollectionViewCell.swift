//
//  AlphabetCollectionViewCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

public final class AlphabetCollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var label: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? AlphabetAdapterProtocol else {
            fatalError("AlphabetAdapterProtocol required")
        }
        label.attributedText = adapter.label
    }

}

public protocol AlphabetAdapterProtocol: CollectionAdapter {
    var label: NSAttributedString { get }
}

public struct AlphabetAdapter: AlphabetAdapterProtocol {
    public let label: NSAttributedString
    public init(country: String) {
        label = NSAttributedString(string: country)
    }

}

public final class AlphabetDescriptor: CollectionCellDescribable {
    
    public let identifier: String = "AlphabetCollectionViewCell"
    public let className: String = "AlphabetCollectionViewCell"
    public var selectable: Bool = false
    
    let adapter: AlphabetAdapterProtocol
    
    public init(adapter: AlphabetAdapterProtocol) {
        self.adapter = adapter
    }
    
    public func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width: CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right - 80
        return CGSize(width: width, height: adapter.label.height(width))
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
