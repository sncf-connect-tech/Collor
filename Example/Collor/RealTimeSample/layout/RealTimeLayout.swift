//
//  RealTimeLayout.swift
//  Collor
//
//  Created by Guihal Gwenn on 06/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class RealTimeLayout: UICollectionViewFlowLayout {
    
    unowned fileprivate let datas: CollectionData
    fileprivate lazy var decorationViewHandler:DecorationViewsHandler = DecorationViewsHandler(collectionViewLayout: self)
    
    fileprivate let sectionBackgroundKind = "sectionBackground"
    fileprivate let cellBackgroundKind = "cellBackground"
    
    let sectionMargin:CGFloat = 5
    let infoMargin:CGFloat = 5
    
    init(datas: CollectionData) {
        self.datas = datas
        super.init()
        
        decorationViewHandler.register(viewClass: SimpleDecorationView.self, for: sectionBackgroundKind)
        decorationViewHandler.register(viewClass: SimpleDecorationView.self, for: cellBackgroundKind)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        decorationViewHandler.prepare()
        
        datas.sections.forEach { sectionDescriptor in
            
            guard
                let firstCellDescriptor = sectionDescriptor.cells.first,
                let firstCellIndexPath = firstCellDescriptor.indexPath,
                let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath),
                let lastCellIndexPath = sectionDescriptor.cells.last?.indexPath,
                let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)
            else {
                return
            }
            
            // section background
            let origin = CGPoint(x: 0 + sectionMargin, y: firstCellAttributes.frame.origin.y - sectionMargin)
            let width = collectionView.bounds.width - sectionMargin*2
            let height = lastCellAttributes.frame.maxY - origin.y + sectionMargin
            
            let backgroundAttributes = SimpleDecorationViewLayoutAttributes(forDecorationViewOfKind: sectionBackgroundKind, with: firstCellIndexPath)
            backgroundAttributes.backgroundColor = (firstCellDescriptor.getAdapter() as? TweetAdapter)?.backgroundColor ?? .twitterBlue
            backgroundAttributes.cornerRadius = 4
            backgroundAttributes.zIndex = -2
            backgroundAttributes.frame = CGRect(x: origin.x,
                                                y: origin.y,
                                                width: width,
                                                height: height)
            
            decorationViewHandler.add(attributes: backgroundAttributes)
            
            // cell background
            sectionDescriptor.cells.filter { $0 is TweetInfoDescriptor }.forEach { cellDescriptor in
                guard
                    let cellIndexPath = cellDescriptor.indexPath,
                    let cellAttributes = layoutAttributesForItem(at: cellIndexPath)
                else {
                        return
                }
                
                let backgroundAttributes = SimpleDecorationViewLayoutAttributes(forDecorationViewOfKind: cellBackgroundKind, with: cellIndexPath)
                backgroundAttributes.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                backgroundAttributes.cornerRadius = 4
                backgroundAttributes.zIndex = -1
                backgroundAttributes.frame = cellAttributes.frame.insetBy(dx: -infoMargin, dy: infoMargin)
                
                decorationViewHandler.add(attributes: backgroundAttributes)
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let decorationAttributes = decorationViewHandler.attributes(in:rect)
        if let attributes = attributes {
            return attributes + decorationAttributes
        }
        return attributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at atIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationViewHandler.attributes(for: elementKind, at: atIndexPath)
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        decorationViewHandler.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return decorationViewHandler.inserted(for: elementKind)
    }
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return decorationViewHandler.deleted(for: elementKind)
    }
}

