//
//  PantoneViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 08/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

final class PantoneViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: nil)
    
    var metallicPantone = MetallicPantone()
    let collectionData = PantoneCollectionData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pantone Metallic"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PantoneViewController.add))
        enableAddButon()

        collectionData.reload(model: metallicPantone)
        
        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
    }
    
    func enableAddButon() {
        navigationItem.rightBarButtonItem?.isEnabled = !metallicPantone.notUsed.isEmpty
    }
    
    func add() {
        // get a random visible indexPath
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let randomIndexPath = visibleIndexPaths[ Int(arc4random_uniform(UInt32(visibleIndexPaths.count))) ]
        
        if let cellDescriptor = collectionData.cellDescribable(at: randomIndexPath) as? PantoneColorDescriptor {
            let hexaColor = metallicPantone.add() // update model
            
            let newCellDescriptor = PantoneColorDescriptor(adapter: PantoneColorAdapter(hexaColor: hexaColor)) // update collectionView Data
            let result = collectionData.update { updater in
                updater.append(cells: [newCellDescriptor], after: cellDescriptor)
            }
            collectionView.performUpdates(with: result)
        }
        enableAddButon()
    }
}

extension PantoneViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {
        switch (cellDescriptor.getAdapter()) {
        case (let adapter as PantoneColorAdapter):
            metallicPantone.remove(hexaColor: adapter.hexaColor)
            
            let result = collectionData.update { updater in
                updater.remove(cells: [cellDescriptor])
            }
            collectionView.performUpdates(with: result)
            
            enableAddButon()
        default:
            break
        }
    }
}
