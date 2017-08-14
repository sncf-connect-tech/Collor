//
//  RandomViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class RandomViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)

    var crew = Crew()
    let collectionData = RandomCollectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(RandomViewController.randomize))
        
        collectionData.reload(crew: crew)
        collectionView.collectionViewLayout = WhiteSectionLayout(datas: collectionData)
        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
    }
    
    func randomize() {
        crew.randomize()
        let result = collectionData.update { updater in
            collectionData.reload(crew: crew)
            updater.diff()
        }
        collectionView.performUpdates(with: result)

    }
}

extension RandomViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {}
}

extension RandomViewController : CollectionUserEventDelegate {
    
}
