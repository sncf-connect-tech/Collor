//
//  PantoneSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 08/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor
import CoreGraphics

final class PantoneSectionDescriptor : CollectionSectionDescribable {
    
    static let margin:CGFloat = 2
    
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: PantoneSectionDescriptor.margin, bottom: 0, right: PantoneSectionDescriptor.margin)
    }
    func minimumLineSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return PantoneSectionDescriptor.margin
    }
    func minimumInteritemSpacing(_ collectionView: UICollectionView, layout: UICollectionViewFlowLayout) -> CGFloat {
        return PantoneSectionDescriptor.margin
    }
}
