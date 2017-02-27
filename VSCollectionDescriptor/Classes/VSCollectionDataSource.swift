//
//  VSCollectionDataSource.swift
//  VSC
//
//  Created by Bousquet Romain on 30/06/2016.
//  Copyright © 2016 VSCT. All rights reserved.
//

import Foundation

public class VSCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    public var collectionDatas: VSCollectionDatas?
    public unowned var delegate:VSCollectionUserEventDelegate
    
    public init(delegate:VSCollectionUserEventDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    // MARK: UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionDatas?.sectionsCount() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDatas?.sections[section].cells.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellDescriptor = collectionDatas?.sections[indexPath.section].cells[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        if let collectionDatas = collectionDatas, collectionDatas.registeredCells.contains(cellDescriptor.identifier) == false {
            let nib = UINib(nibName: cellDescriptor.className, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellDescriptor.identifier)
            collectionDatas.registeredCells.insert(cellDescriptor.identifier)
        }
 
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDescriptor.identifier, for: indexPath) as? VSCollectionCellProtocol else {
            return UICollectionViewCell()
        }
        
        cell.updateWithAdapter(adapter: cellDescriptor.adapter)
        cell.setDelegate(delegate)
        return cell as? UICollectionViewCell ?? UICollectionViewCell()
    }
    
}
