//
//  VSCollectionAdaptable.swift
//  VSC
//
//  Created by Guihal Gwenn on 06/10/16.
//  Copyright © 2016 VSCT. All rights reserved.
//

public protocol VSCollectionAdapter {}

// MARK - VSCollectionSectionDescriptor
public protocol VSCollectionSectionDescriptor : class {
    var cells: [VSCollectionCellDescriptor] { get set}
    func sectionInset(_ collectionView: UICollectionView) -> UIEdgeInsets
    func minimumInteritemSpacing(_ collectionView: UICollectionView) -> Int
}

// MARK: VSCollectionSectionStylingDescriptor
public protocol VSCollectionSectionStylingDescriptor {
    var styleGroup: [VSCollectionGroupStyleDescriptor] { get set }
    var backgroundColor: UIColor? { get }
}

// MARK: VSCollectionGroupStyleDescriptor for cell styling
public protocol VSCollectionGroupStyleDescriptor {
    var first: VSCollectionCellDescriptor { get set }
    var last: VSCollectionCellDescriptor { get set }
    var backgroundColor: UIColor? { get }
    var inset: UIEdgeInsets? { get }
}

// default implementation VSCollectionSectionDescriptor
public extension VSCollectionSectionDescriptor {
    func minimumInteritemSpacing(_ collectionView:UICollectionView) -> Int {
        return 10
    }
}

public extension VSCollectionSectionDescriptor {
    func ipadInsetX(_ collectionView:UICollectionView) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? (collectionView.bounds.width - 414) * 0.5 : 0;
    }
}

// MARK - VSCollectionCellDescriptor
public protocol VSCollectionCellDescriptor : class {
    var identifier: String { get }
    var className: String { get }
    var adapter: VSCollectionAdapter { get }
    var selectable: Bool { get }
    var indexPath:IndexPath! { get set }
    func size(_ collectionView: UICollectionView, sectionDescriptor: VSCollectionSectionDescriptor) -> CGSize
}

// MARK - VSCollectionCellProtocol
public protocol VSCollectionCellProtocol : NSObjectProtocol {
    func updateWithAdapter(adapter aAdapter: VSCollectionAdapter) -> Void
    func setDelegate(_ delegate:VSCollectionUserEventDelegate) -> Void
}

// default implementation of VSCollectionCellProtocol
public extension VSCollectionCellProtocol {
    func setDelegate(_ delegate:VSCollectionUserEventDelegate) {}
}


// MARK - CollectionView DataSource & Delegate
public protocol VSCollectionDidSelectCellDelegate : NSObjectProtocol {
    func didSelectCell(_ cellDescriptor: VSCollectionCellDescriptor, sectionDescriptor: VSCollectionSectionDescriptor, indexPath: IndexPath)
}

public protocol VSCollectionUserEventDelegate : NSObjectProtocol {
    
}
