//
//  TestLayout.swift
//  Collor_Tests
//
//  Created by Guihal Gwenn on 13/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class TestLayout : UICollectionViewFlowLayout {
    
    unowned fileprivate let datas: CollectionData
    fileprivate lazy var supplementaryViewsHandler = SupplementaryViewsHandler(collectionViewLayout: self)
    
    init(datas: CollectionData) {
        self.datas = datas
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        supplementaryViewsHandler.prepare()
        
        for (sectionIndex, sectionDescriptor) in datas.sections.enumerated() {
            
            sectionDescriptor.supplementaryViews.forEach { (kind, views) in
                var dict = [IndexPath : UICollectionViewLayoutAttributes]()
                views.enumerated().forEach { (index, viewDescriptor) in
                    let indexPath = IndexPath(item: index, section: sectionIndex)
                    let a = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                    dict[indexPath] = a
                    
                    supplementaryViewsHandler.add(attributes: a)
                }
            }
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let supplementaryAttributes = supplementaryViewsHandler.attributes(in: rect)
        if let attributes = attributes {
            return attributes + supplementaryAttributes
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryViewsHandler.attributes(for: elementKind, at: indexPath)
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        supplementaryViewsHandler.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override func indexPathsToInsertForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
        return supplementaryViewsHandler.inserted(for: elementKind)
    }
    
    override func indexPathsToDeleteForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
        return supplementaryViewsHandler.deleted(for: elementKind)
    }
}
