//
//  AlphabetViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class AlphabetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)

    let collectionData = AlphabetCollectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
        collectionView.collectionViewLayout = AlphabetLayout(datas: collectionData)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AlphabetViewController.add)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(AlphabetViewController.reset))
        ]
    }
    
    @objc func reset() {
        let updateResult = collectionData.reset()
        collectionView.performUpdates(with: updateResult)
    }
    
    @objc func add() {
        let updateResult = collectionData.add()
        collectionView.performUpdates(with: updateResult)
    }
}

extension AlphabetViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {}
}

extension AlphabetViewController : CollectionUserEventDelegate {
    
}
