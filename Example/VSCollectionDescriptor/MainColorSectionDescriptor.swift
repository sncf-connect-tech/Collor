//
//  MainColorSectionDescriptor.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation
import UIKit

class MainColorSectionDescriptor: VSCollectionSectionDescriptor {
    
    var cells = [VSCollectionCellDescriptor]()
    
    func sectionInset(_ collectionView:UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

