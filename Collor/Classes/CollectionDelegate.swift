//
//  CollectionDelegate.swift
//  VSC
//
//  Created by Guihal Gwenn on 29/06/16.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation
import UIKit

public class CollectionDelegate: NSObject, UICollectionViewDelegate {
    
    public var collectionData: CollectionData?
    public weak var delegate: CollectionDidSelectCellDelegate?
    
    public init(delegate: CollectionDidSelectCellDelegate?) {
        self.delegate = delegate
        super.init()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let sectionDescriptor = collectionData?.sections[indexPath.section] {
            let cellDescriptor = sectionDescriptor.cells[indexPath.item]
            return cellDescriptor.selectable
        }
        return false
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sectionDescriptor = collectionData?.sections[indexPath.section] {
            let cellDescriptor = sectionDescriptor.cells[indexPath.item]
            delegate?.didSelect(cellDescriptor, sectionDescriptor: sectionDescriptor, indexPath: indexPath)
        }
    }
    
}

extension CollectionDelegate : UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let sectionDescriptor = collectionData?.sections[indexPath.section] {
            let cellDescriptor = sectionDescriptor.cells[indexPath.item]
            return cellDescriptor.size(collectionView, sectionDescriptor: sectionDescriptor)
        }
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let sectionDescriptor = collectionData?.sections[section] {
            return sectionDescriptor.sectionInset(collectionView)
        }
        return UIEdgeInsets()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        
        if let sectionDescriptor = collectionData?.sections[section] {
            return sectionDescriptor.minimumInteritemSpacing(collectionView, layout: layout)
        }
        return layout.minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        
        if let sectionDescriptor = collectionData?.sections[section] {
            return sectionDescriptor.minimumLineSpacing(collectionView, layout: layout)
        }
        return layout.minimumLineSpacing
    }
}
