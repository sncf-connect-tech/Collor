//
//  RealTimeViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class RealTimeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)

    let collectionData = RealTimeCollectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
    }
}

extension RealTimeViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {}
}

extension RealTimeViewController : CollectionUserEventDelegate {
    
}
