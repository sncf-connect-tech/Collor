//
//  AlphabetLayout.swift
//  Collor_Example
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor


class AlphabetLayout : UICollectionViewFlowLayout {
    
    unowned fileprivate let datas: CollectionData
    
    fileprivate var supplementaryAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()

    init(datas: CollectionData) {
        self.datas = datas
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        for (sectionIndex, sectionDescriptor) in datas.sections.enumerated() {
            
            let firstCellIndexPath = IndexPath(item: 0, section: sectionIndex)
            let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath)!
            
            sectionDescriptor.supplementaryViews.forEach { (kind, views) in
                var dict = [IndexPath : UICollectionViewLayoutAttributes]()
                views.enumerated().forEach { (index, viewDescriptor) in
                    let indexPath = IndexPath(item: index, section: sectionIndex)
                    let a = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                    a.frame = CGRect(x: 0,
                                     y: firstCellAttributes.frame.origin.y,
                                     width: 80,
                                     height: 80)
                    dict[indexPath] = a
                }
                if let d = supplementaryAttributes[kind] {
                    let new = d.merging(dict) { (current, _) in current }
                    supplementaryAttributes[kind] = new
                } else {
                    supplementaryAttributes[kind] = dict
                }
            }
            
//            let firstCellIndexPath = IndexPath(item: 0, section: sectionIndex)
//            let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath)!
//
//            let lastCellIndexPath = IndexPath(item: sectionDescriptor.cells.count - 1, section: sectionIndex)
//            let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)!
//
//            let origin = CGPoint(x: 0 + backgroundMargin, y: firstCellAttributes.frame.origin.y - backgroundMargin)
//            let width = collectionView.bounds.width - backgroundMargin*2
//            let height = lastCellAttributes.frame.maxY - origin.y + backgroundMargin
//
//            // header
//            let backgroundAttributes = SimpleDecorationViewLayoutAttributes(forDecorationViewOfKind: sectionBackgroundKind, with: firstCellIndexPath)
//            backgroundAttributes.backgroundColor = UIColor.white
//            backgroundAttributes.cornerRadius = 4
//            backgroundAttributes.zIndex = -10
//            backgroundAttributes.frame = CGRect(x: origin.x,
//                                                y: origin.y,
//                                                width: width,
//                                                height: height)
//
//            decorationAttributes[sectionBackgroundKind]![firstCellIndexPath] = backgroundAttributes
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let attributes = attributes {
            return attributes
                + supplementaryAttributes.flatMap { $0.value }.map { $0.value }
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryAttributes[elementKind]?[indexPath]
    }
}
