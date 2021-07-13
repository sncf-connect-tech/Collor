//
//  TextFieldSectionDescriptor.swift
//  Collor_Example
//
//  Created by Deffrasnes Ghislain on 07/05/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class TextFieldSectionDescriptor: CollectionSectionDescribable {

    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
