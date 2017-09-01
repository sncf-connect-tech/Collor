//
//  WhiteSectionLayout.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor
import Dwifft

class WhiteSectionLayout: UICollectionViewFlowLayout {
    
    unowned fileprivate let datas: CollectionData
    fileprivate var decorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()
    fileprivate var oldDecorationAttributes = [String : [IndexPath : UICollectionViewLayoutAttributes]]()
    
    fileprivate let sectionBackgroundKind = "sectionBackground"
    
    let backgroundMargin:CGFloat = 0
    
    
    init(datas: CollectionData) {
        self.datas = datas
        super.init()
        
        decorationAttributes[sectionBackgroundKind] = [IndexPath : UICollectionViewLayoutAttributes]()
        register(SectionDecorationView.self, forDecorationViewOfKind: sectionBackgroundKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        oldDecorationAttributes = decorationAttributes
        
        decorationAttributes[sectionBackgroundKind]!.removeAll()
        
        guard let collectionView = collectionView else {
            return
        }
        
        for (sectionIndex, sectionDescriptor) in datas.sections.enumerated() {
            
            guard (sectionDescriptor as? SectionDecorable)?.hasBackground == true else {
                continue
            }
            
            sectionDescriptor.cells.forEach { cell in
                
                let firstCellIndexPath = cell.indexPath!//IndexPath(item: 0, section: sectionIndex)
                let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath)!
                
                let lastCellIndexPath = cell.indexPath!//IndexPath(item: sectionDescriptor.cells.count - 1, section: sectionIndex)
                let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)!
                
                let origin = CGPoint(x: 0 + backgroundMargin, y: firstCellAttributes.frame.origin.y - backgroundMargin)
                let width = collectionView.bounds.width - backgroundMargin*2
                let height = lastCellAttributes.frame.maxY - origin.y + backgroundMargin
                
                // header
                let backgroundAttributes = SectionDecorationViewLayoutAttributes(forDecorationViewOfKind: sectionBackgroundKind, with: firstCellIndexPath)
                if let suid = sectionDescriptor.uid(), let uid = cell.uid() {
                    backgroundAttributes.uid( suid + "/" + uid )
                }
                backgroundAttributes.backgroundColor = UIColor.red
                backgroundAttributes.cornerRadius = 4
                backgroundAttributes.zIndex = -10
                backgroundAttributes.frame = CGRect(x: origin.x,
                                                    y: origin.y,
                                                    width: width,
                                                    height: height)
                
                decorationAttributes[sectionBackgroundKind]![firstCellIndexPath] = backgroundAttributes
                
            }
        }
    }
    
    var insertedDecorationAttributes = [String:[IndexPath]]()
    var deletedDecorationAttributes = [String:[IndexPath]]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        // set of kind
        //        var keys = decorationAttributes.flatMap{$0.key}
        //        keys.append(contentsOf: oldDecorationAttributes.flatMap{$0.key})
        
        insertedDecorationAttributes.removeAll()
        deletedDecorationAttributes.removeAll()
        
        let kinds = Set(decorationAttributes.flatMap{$0.key} + oldDecorationAttributes.flatMap{$0.key})
        kinds.forEach { kind in
            
            insertedDecorationAttributes[kind] = [IndexPath]()
            deletedDecorationAttributes[kind] = [IndexPath]()
            
            let old = oldDecorationAttributes[kind]?.map{ ($0.value.indexPath,$0.value.uid()!) }.sorted(by: { $0.0.0 < $0.1.0 }).map { $0.1 } ?? [String]()
            let new = decorationAttributes[kind]?.map{ ($0.value.indexPath,$0.value.uid()!) }.sorted(by: { $0.0.0 < $0.1.0 }).map { $0.1 }    ?? [String]()
            
            let myDiff = ListDiff<String>(before: old, after: new)
            print(myDiff.added)
            print(myDiff.deleted)
            print(myDiff.moved)
            
            let difft = Dwifft.diff(old, new)
            
            let oldAttributes = oldDecorationAttributes[kind]?.flatMap{ $0.value.indexPath }.sorted() ?? [IndexPath]()
            let newAttributes = decorationAttributes[kind]?.flatMap{ $0.value.indexPath }.sorted() ?? [IndexPath]()
            let diff = Dwifft.diff(oldAttributes, newAttributes)
            diff.forEach { diffStep in
                switch diffStep {
                case .delete(_, let attribute):
                    deletedDecorationAttributes[kind]!.append(attribute)
                case .insert(_, let attribute):
                    insertedDecorationAttributes[kind]!.append(attribute)
                }
            }
        }
        print("deletedDecorationAttributes \(deletedDecorationAttributes)")
        print("insertedDecorationAttributes \(insertedDecorationAttributes)")
        
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
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return deletedDecorationAttributes[elementKind]!
    }
    
    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return insertedDecorationAttributes[elementKind]!
    }
    
    //    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        return decorationAttributes[elementKind]![decorationIndexPath]
    //    }
    //
    //    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        return oldDecorationAttributes[elementKind]![decorationIndexPath]
    //    }
}

class ListDiff<T : Hashable> {
    typealias IndexValue = (index:Int, value:T)
    typealias IndexList = [IndexValue]
    typealias FromIndexToIndexList = [(from: IndexValue, to: IndexValue)]
    
    // A list of indexes of where items were added.
    let added: IndexList
    // A list of indexes where items that have disappeared used to be.
    let deleted: IndexList
    // A list of tuples of indexes representing the old and new indexes of items that moved.
    let moved: FromIndexToIndexList
    
    init(before: [T], after: [T]) {
        // Create a map with all the items in the smaller list mapped to indexes.
        let beforeIsSmaller = before.count < after.count
        var map = [T: Int]()
        for (index, item) in (beforeIsSmaller ? before : after).enumerated() {
            map[item] = index
        }
        
        var added = IndexList()
        var deleted = IndexList()
        var moved = FromIndexToIndexList()
        
        // Loop through the longer list to calculate all changed indexes.
        for (index1, item) in (beforeIsSmaller ? after : before).enumerated() {
            if let index2 = map[item] {
                if (index1 != index2) {
                    let (from, to) = beforeIsSmaller ? ((index2,item), (index1,item)) : ((index1,item), (index2,item))
                    moved.append((from: from, to: to))
                }
                map.removeValue(forKey: item)
            } else {
                if (beforeIsSmaller) {
                    added.append((index1,item))
                } else {
                    deleted.append((index1,item))
                }
            }
        }
        
        // Handle any indexes still in the map.
        for (item, index) in map {
            if (beforeIsSmaller) {
                deleted.append((index,item))
            } else {
                added.append((index,item))
            }
        }
        
        self.added = added
        self.deleted = deleted
        self.moved = moved
    }
}

