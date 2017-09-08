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
    fileprivate var decorationAttributes = DecorationAttributes()
    fileprivate var oldDecorationAttributes = DecorationAttributes()
    
    fileprivate let sectionBackgroundKind = "sectionBackground"
    fileprivate let cellBackgroundKind = "cellBackground"
    
    let sectionMargin:CGFloat = 5
    let infoMargin:CGFloat = 5
    
    init(datas: CollectionData) {
        self.datas = datas
        super.init()
        
        decorationAttributes[sectionBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        decorationAttributes[cellBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        
        register(SimpleDecorationView.self, forDecorationViewOfKind: sectionBackgroundKind)
        register(SimpleDecorationView.self, forDecorationViewOfKind: cellBackgroundKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        
        oldDecorationAttributes = decorationAttributes
        
        super.prepare()
        
        decorationAttributes[sectionBackgroundKind]!.removeAll()
        decorationAttributes[cellBackgroundKind]!.removeAll()
        
        guard let collectionView = collectionView else {
            return
        }
        
        datas.sections.forEach { sectionDescriptor in
            
            guard
                let firstCellDescriptor = sectionDescriptor.cells.first,
                let firstCellIndexPath = firstCellDescriptor.indexPath,
                let firstCellUid = sectionDescriptor.uid(for: firstCellDescriptor),
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
            backgroundAttributes.uid( firstCellUid )
            backgroundAttributes.backgroundColor = (firstCellDescriptor.getAdapter() as? TweetAdapter)?.backgroundColor ?? .twitterBlue
            backgroundAttributes.cornerRadius = 4
            backgroundAttributes.zIndex = -2
            backgroundAttributes.frame = CGRect(x: origin.x,
                                                y: origin.y,
                                                width: width,
                                                height: height)
            
            decorationAttributes[sectionBackgroundKind]![firstCellIndexPath] = backgroundAttributes
            
            // cell background
            sectionDescriptor.cells.filter { $0 is TweetInfoDescriptor }.forEach { cellDescriptor in
                guard
                    let cellIndexPath = cellDescriptor.indexPath,
                    let cellAttributes = layoutAttributesForItem(at: cellIndexPath),
                    let cellUid = sectionDescriptor.uid(for: cellDescriptor)
                    else {
                        return
                }
                
                let backgroundAttributes = SimpleDecorationViewLayoutAttributes(forDecorationViewOfKind: cellBackgroundKind, with: cellIndexPath)
                backgroundAttributes.uid( cellUid )
                backgroundAttributes.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                backgroundAttributes.cornerRadius = 4
                backgroundAttributes.zIndex = -1
                backgroundAttributes.frame = cellAttributes.frame.insetBy(dx: -infoMargin, dy: infoMargin)
                
                decorationAttributes[cellBackgroundKind]![cellIndexPath] = backgroundAttributes
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let attributes = attributes {
            return attributes
                + decorationAttributes[sectionBackgroundKind]!.values
                + decorationAttributes[cellBackgroundKind]!.values
        }
        return attributes?.filter{ $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at atIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationAttributes[elementKind]![atIndexPath]
    }
    
    var decorationDiff:DecorationDiff?
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        decorationDiff = diff(oldDecorationAttributes: oldDecorationAttributes, newDecorationAttributes: decorationAttributes)
        
    }
    
    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return decorationDiff?.inserted[elementKind]! ?? []
    }
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return decorationDiff?.deleted[elementKind]! ?? []
    }
}

