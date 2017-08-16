//
//  Helpers.swift
//  Pods
//
//  Created by Guihal Gwenn on 17/03/17.
//
//

import UIKit
import Foundation

public func bind(collectionView: UICollectionView, with data: CollectionData, and collectionViewDelegate: CollectionDelegate, and collectionViewDatasource: CollectionDataSource) {
    
    collectionViewDelegate.collectionData = data
    collectionViewDatasource.collectionData = data
    
    collectionView.delegate = collectionViewDelegate
    collectionView.dataSource = collectionViewDatasource
    
    data.reloadData()
}
