//
//  LetterCollectionReusableView.swift
//  Collor_Example
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class LetterCollectionReusableViewDescriptor : CollectionSupplementaryViewDescribable {
    var identifier: String = "LetterCollectionReusableView"
    var className: String = "LetterCollectionReusableView"
    
    let adapter: LetterAdapter
    
    init(adapter: LetterAdapter) {
        self.adapter = adapter
    }
    
    func getAdapter() -> CollectionAdapter {
        return adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        return .zero
    }
}

struct LetterAdapter: CollectionAdapter {
    var letter: String
    
    init(letter: String) {
        self.letter = letter
    }
}

class LetterCollectionReusableView: UICollectionReusableView, CollectionSupplementaryViewAdaptable {

    @IBOutlet weak var label: UILabel!
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? LetterAdapter else {
            fatalError("LetterAdapter required")
        }
        self.label.text = adapter.letter
    }
    
}
