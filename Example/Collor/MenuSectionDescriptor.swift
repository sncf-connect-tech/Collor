//
//  MenuSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class MenuSectionDescriptor: CollectionSectionDescribable {
    
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
