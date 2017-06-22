//
//  ViewController.swift
//  Collor
//
//  Created by myrddinus on 02/22/2017.
//  Copyright (c) 2017 myrddinus. All rights reserved.
//

import Collor
import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var demoDatas = DemoDatas()
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)
    
    var expanded = [IndexPath:[CollectionCellDescribable]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demo App"
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        
        bind(collectionView: collectionView, with: demoDatas, and: collectionViewDelegate, and: collectionViewDatasource)
        
        collectionView.backgroundColor = UIColor.clear
    }
}

extension ViewController : CollectionDidSelectCellDelegate {

    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {
        switch (cellDescriptor, cellDescriptor.getAdapter()) {
            
        case (is ColorDescriptor, _):
            let result = demoDatas.update { updater in
                updater.remove(cells: [cellDescriptor])
            }
            collectionView.performUpdates(with: result)
        
        case (_, let adapter as TitleAdapter):
            
//            var result:UpdateCollectionResult!
//            
//            if let expandedCells = expanded[cellDescriptor.indexPath] {
//                result = demoDatas.collapse(cells: expandedCells)
//                expanded[cellDescriptor.indexPath] = nil
//            } else {
                //result = demoDatas.expand(titleDescriptor: cellDescriptor, color: adapter.color)
                //expanded[cellDescriptor.indexPath] = result.insertedCellDescriptors
            if demoDatas.expanded == adapter.color {
                demoDatas.expanded = nil
            } else {
                demoDatas.expanded = adapter.color
            }
                let result = demoDatas.update{ updater in
                    updater.reloadData()
                }
            
                collectionView.performUpdates(with: result)
//                demoDatas.reloadData()
//                collectionView.reloadData()
//            }
            // same as :
//            collectionView?.performBatchUpdates {
//                self.collectionView?.deleteItems(at: result.deletedIndexPaths)
//                self.collectionView?.insertItems(at: result.insertedIndexPaths)
//            }
            
        case (_, let adapter as ActionAdapter):
            switch adapter.action {
            case .addSection:
                let result = demoDatas.addSection()
                collectionView.performUpdates(with: result)
            case .removeSection:
                if let result = demoDatas.removeRandomSection() {
                    collectionView.performUpdates(with: result)
                }
            }
            
        default:
            break
        }
    }
}

extension ViewController : UserEventDelegate {
    func onUserEvent(_ event: UserEvent, cell: UICollectionViewCell) {
        
        if demoDatas.sections.count <= 1 {
            return
        }
        
        let cellElseSection = arc4random_uniform(100) > 50
        let randomSectionIndex = 1 + Int(arc4random_uniform( UInt32(demoDatas.sections.count) - 1))
        let section = demoDatas.sections[randomSectionIndex]
        if cellElseSection {
            let randomCellIndex = Int(arc4random_uniform( UInt32(section.cells.count) - 1))
            let cell = section.cells[randomCellIndex]
            let result = demoDatas.update { updater in
                updater.reload(cells: [cell])
            }
            collectionView.performUpdates(with: result)
            
        } else {
            let result = demoDatas.update { updater in
                updater.reload(sections: [section])
            }
            collectionView.performUpdates(with: result)
        }
    }
}
