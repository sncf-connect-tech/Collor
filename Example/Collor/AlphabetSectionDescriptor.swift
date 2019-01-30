//
//  AlphabetSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class AlphabetSectionDescriptorSectionDescriptor: CollectionSectionDescribable {
    
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}
