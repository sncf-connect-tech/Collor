//
//  CollectionAdapter.swift
//  VSC
//
//  Created by Guihal Gwenn on 06/10/16.
//  Copyright © 2016 VSCT. All rights reserved.
//

public protocol CollectionAdapter {
}

// MARK - CollectionSectionDescriptable
public protocol CollectionSectionDescriptable : class {
    var cells: [CollectionCellDescriptable] { get set}
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView) -> Int
}

// default implementation CollectionSectionDescriptable
public extension CollectionSectionDescriptable {
    func minimumInteritemSpacing(_ collectionView:UICollectionView) -> Int {
        return 10
    }
}

// MARK - CollectionCellDescriptable
public protocol CollectionCellDescriptable : class {
    var identifier: String { get }
    var className: String { get }
    var adapter: CollectionAdapter { get }
    var selectable: Bool { get }
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescriptable) -> CGSize
    
    var indexPath:IndexPath! { get set }
}

// MARK - CollectionCellAdaptable
public protocol CollectionCellAdaptable : NSObjectProtocol {
    func update(with adapter: CollectionAdapter) -> Void
    func set(delegate delegate:CollectionUserEventDelegate) -> Void
}

// default implementation of CollectionCellAdaptable
public extension CollectionCellAdaptable {
    func set(delegate delegate:CollectionUserEventDelegate) {}
}


// MARK - CollectionView DataSource & Delegate
public protocol CollectionDidSelectCellDelegate : NSObjectProtocol {
    func didSelect(_ cellDescriptor: CollectionCellDescriptable, sectionDescriptor: CollectionSectionDescriptable, indexPath: IndexPath)
}

public protocol CollectionUserEventDelegate : NSObjectProtocol {
    
}
