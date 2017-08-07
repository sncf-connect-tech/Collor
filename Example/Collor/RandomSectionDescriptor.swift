//
//  RandomSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

class RandomSectionDescriptor: CollectionSectionDescribable, SectionDecorable {
    var hasBackground: Bool = true
    
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
