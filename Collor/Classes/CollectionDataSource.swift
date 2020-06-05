//
//  CollectionDataSource.swift
//  VSC
//
//  Created by Guihal Gwenn on 20/02/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation

public class CollectionDataSource: NSObject, UICollectionViewDataSource {
    
    public var collectionData: CollectionData?
    public weak var delegate: CollectionUserEventDelegate?
    
    public init(delegate: CollectionUserEventDelegate?) {
        self.delegate = delegate
        super.init()
    }
    
    // MARK: UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionData?.computeIndices()
        return collectionData?.sectionsCount() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionData = collectionData else {
            return UICollectionReusableView()
        }
        guard let supplementaryDescriptor = collectionData.sections[indexPath.section].supplementaryViews[kind]?[indexPath.item] else {
            return UICollectionReusableView()
        }
        register(supplementaryDescriptor: supplementaryDescriptor, for: kind, in: collectionView)
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryDescriptor.identifier, for: indexPath) as? CollectionSupplementaryViewAdaptable else {
            return UICollectionReusableView()
        }
        view.update(with: supplementaryDescriptor.getAdapter() )
        return view as! UICollectionReusableView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData?.sections[section].cells.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionData = collectionData else {
            return UICollectionViewCell()
        }
        
        let cellDescriptor = collectionData.sections[indexPath.section].cells[indexPath.item]
        register(cellDescriptor: cellDescriptor, in: collectionView)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDescriptor.identifier, for: indexPath) as? CollectionCellAdaptable else {
            return UICollectionViewCell()
        }
        
        
        cell.update(with: cellDescriptor.getAdapter() )
        cell.set(delegate: delegate)
        return cell as! UICollectionViewCell
    }
}

extension CollectionDataSource {
    private func register(cellDescriptor: CollectionCellDescribable, in collectionView: UICollectionView) {
        
        guard let collectionData = collectionData else {
            return
        }
        
        if collectionData.registeredCells.contains(cellDescriptor.identifier) == false {
            if cellDescriptor.bundle.path(forResource: cellDescriptor.className, ofType: "nib") != nil {
                let nib = UINib(nibName: cellDescriptor.className, bundle: cellDescriptor.bundle)
                collectionView.register(nib, forCellWithReuseIdentifier: cellDescriptor.identifier)
            }
            else if let cellClass = Bundle.main.classNamed(cellDescriptor.className) as? UICollectionViewCell.Type {
                collectionView.register(cellClass, forCellWithReuseIdentifier: cellDescriptor.identifier)
            }
            else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
                let cellClass = Bundle.main.classNamed("\(bundleName).\(cellDescriptor.className)") as? UICollectionViewCell.Type {
                collectionView.register(cellClass, forCellWithReuseIdentifier: cellDescriptor.identifier)
            }
            else {
                return
            }
            
            collectionData.registeredCells.insert(cellDescriptor.identifier)
        }
    }
    
    private func register(supplementaryDescriptor: CollectionSupplementaryViewDescribable, for kind: String, in collectionView: UICollectionView) {
        
        guard let collectionData = collectionData else {
            return
        }
        
        if collectionData.registeredSupplementaryViews.contains(supplementaryDescriptor.identifier) == false {
            if supplementaryDescriptor.bundle.path(forResource: supplementaryDescriptor.className, ofType: "nib") != nil {
                let nib = UINib(nibName: supplementaryDescriptor.className, bundle: supplementaryDescriptor.bundle)
                collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryDescriptor.identifier)
            }
            else if let viewClass = Bundle.main.classNamed(supplementaryDescriptor.className) as? UICollectionReusableView.Type {
                collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryDescriptor.identifier)
            }
            else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
                let viewClass = Bundle.main.classNamed("\(bundleName).\(supplementaryDescriptor.className)") as? UICollectionReusableView.Type {
                collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryDescriptor.identifier)
            }
            else {
                return
            }
            
            collectionData.registeredSupplementaryViews.insert(supplementaryDescriptor.identifier)
        }
    }
}
