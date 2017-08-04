//
//  WheaterLayout.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class WheaterLayout: UICollectionViewFlowLayout {
    
    unowned fileprivate let datas: CollectionDatas
    fileprivate var decorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()
    
    fileprivate let sectionBackgroundKind = "sectionBackground"
    
    let backgroundMarginY:CGFloat = 5
    
    
    init(datas: CollectionDatas) {
        self.datas = datas
        super.init()
        
        decorationAttributes[sectionBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        register(WeatherDecorationView.self, forDecorationViewOfKind: sectionBackgroundKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        decorationAttributes[sectionBackgroundKind]!.removeAll()
        
        guard let collectionView = collectionView else {
            return
        }
        
        for (sectionIndex, sectionDescriptor) in datas.sections.enumerated() {
            
            guard sectionDescriptor is WeatherSectionDescriptor else {
                continue
            }
            
            let firstCellIndexPath = IndexPath(item: 0, section: sectionIndex)
            let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath)!
            
            let lastCellIndexPath = IndexPath(item: sectionDescriptor.cells.count - 1, section: sectionIndex)
            let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)!
            
            let origin = CGPoint(x: 0, y: firstCellAttributes.frame.origin.y - backgroundMarginY)
            let width = collectionView.bounds.width
            let height = lastCellAttributes.frame.maxY - origin.y + backgroundMarginY
            
            // header
            let backgroundAttributes = WeatherDecorationViewLayoutAttributes(forDecorationViewOfKind: sectionBackgroundKind, with: firstCellIndexPath)
            backgroundAttributes.borderColor = UIColor.black
            backgroundAttributes.backgroundColor = UIColor.lightGray
            backgroundAttributes.cornerRadius = 4
            backgroundAttributes.zIndex = -2
            backgroundAttributes.frame = CGRect(x: origin.x,
                                                y: origin.y,
                                                width: width,
                                                height: height)
            
            decorationAttributes[sectionBackgroundKind]![firstCellIndexPath] = backgroundAttributes
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let attributes = attributes {
            return attributes
                + decorationAttributes[sectionBackgroundKind]!.values
        }
        return attributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at atIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationAttributes[elementKind]?[atIndexPath]
    }
}

