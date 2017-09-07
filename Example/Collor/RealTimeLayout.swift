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
    fileprivate var decorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()
    fileprivate var oldDecorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()
    
    fileprivate let sectionBackgroundKind = "sectionBackground"
    fileprivate let cellBackgroundKind = "cellBackground"
    
    let backgroundMargin:CGFloat = 5
    
    init(datas: CollectionData) {
        self.datas = datas
        super.init()
        
        decorationAttributes[sectionBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        decorationAttributes[cellBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        
        register(SectionDecorationView.self, forDecorationViewOfKind: sectionBackgroundKind)
        register(SectionDecorationView.self, forDecorationViewOfKind: cellBackgroundKind)
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
            
            guard let sectionUID = sectionDescriptor.uid() else {
                return
            }
            
            guard
                let uid = sectionDescriptor.cells.first?.uid(),
                let firstCellIndexPath = sectionDescriptor.cells.first?.indexPath,
                let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath),
                let lastCellIndexPath = sectionDescriptor.cells.last?.indexPath,
                let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)
            else {
                return
            }
            
            // section background
            let origin = CGPoint(x: 0 + backgroundMargin, y: firstCellAttributes.frame.origin.y - backgroundMargin)
            let width = collectionView.bounds.width - backgroundMargin*2
            let height = lastCellAttributes.frame.maxY - origin.y + backgroundMargin
            
            // header
            let backgroundAttributes = SectionDecorationViewLayoutAttributes(forDecorationViewOfKind: sectionBackgroundKind, with: firstCellIndexPath)
            backgroundAttributes.uid(sectionUID + "/" + uid)
            backgroundAttributes.backgroundColor = UIColor.red
            backgroundAttributes.cornerRadius = 4
            backgroundAttributes.zIndex = -10
            backgroundAttributes.frame = CGRect(x: origin.x,
                                                y: origin.y,
                                                width: width,
                                                height: height)
            
            decorationAttributes[sectionBackgroundKind]![firstCellIndexPath] = backgroundAttributes
            
            // cell background
            sectionDescriptor.cells.filter { $0 is TweetInfoDescriptor }.forEach { cellDescriptor in
                guard
                    let uid = cellDescriptor.uid(),
                    let cellIndexPath = cellDescriptor.indexPath,
                    let cellAttributes = layoutAttributesForItem(at: cellIndexPath)
                    else {
                        return
                }
                
                // header
                let backgroundAttributes = SectionDecorationViewLayoutAttributes(forDecorationViewOfKind: cellBackgroundKind, with: cellIndexPath)
                backgroundAttributes.uid(sectionUID + "/" + uid)
                backgroundAttributes.backgroundColor = UIColor.white
                backgroundAttributes.cornerRadius = 4
                backgroundAttributes.zIndex = -9
                backgroundAttributes.frame = cellAttributes.frame
                
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
        return attributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at atIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationAttributes[elementKind]?[atIndexPath]
    }
    
    var insertedDecorationAttributes = [String:[IndexPath]]()
    var deletedDecorationAttributes = [String:[IndexPath]]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertedDecorationAttributes.removeAll()
        deletedDecorationAttributes.removeAll()
        
        let elementKindKinds = Set(decorationAttributes.flatMap{$0.key} + oldDecorationAttributes.flatMap{$0.key})
        elementKindKinds.forEach { elementKind in
            
            insertedDecorationAttributes[elementKind] = [IndexPath]()
            deletedDecorationAttributes[elementKind] = [IndexPath]()
            
            let old = oldDecorationAttributes[elementKind]?.map{ ($0.value.indexPath,$0.value.uid()!) }.sorted(by: { $0.0.0 < $0.1.0 }) ?? [(IndexPath,String)]()
            let new = decorationAttributes[elementKind]?.map{ ($0.value.indexPath,$0.value.uid()!) }.sorted(by: { $0.0.0 < $0.1.0 })    ?? [(IndexPath,String)]()
            
            var diff = CollorDiff(before: old, after: new)
            
            let inserted = Set(diff.inserted)
            let deleted = Set(diff.deleted)
            let same = inserted.union(deleted)
            same.forEach {
                if decorationAttributes[elementKind]![$0] == oldDecorationAttributes[elementKind]![$0] {
                    diff.inserted.remove(at: diff.inserted.index(of: $0)!)
                    diff.deleted.remove(at: diff.deleted.index(of: $0)!)
                }
            }
            
            diff.inserted.forEach {
                insertedDecorationAttributes[elementKind]!.append($0)
            }
            diff.deleted.forEach {
                deletedDecorationAttributes[elementKind]!.append($0)
            }
        }
    }
    
    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return insertedDecorationAttributes[elementKind]!
    }
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return deletedDecorationAttributes[elementKind]!
    }
}

