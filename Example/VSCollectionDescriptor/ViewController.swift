//
//  ViewController.swift
//  VSCollectionDescriptor
//
//  Created by myrddinus on 02/22/2017.
//  Copyright (c) 2017 myrddinus. All rights reserved.
//

import VSCollectionDescriptor
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var demoDatas = DemoDatas()
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)
    
    var expanded = [IndexPath:[CollectionCellDescriptable]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demo App"
        
        setupCollectionView();
    }
    
    func setupCollectionView() {
        
        bind(collectionView: collectionView, with: demoDatas, and: collectionViewDelegate, and: collectionViewDatasource)
        
        collectionView.backgroundColor = UIColor.clear
    }
}

extension ViewController : CollectionDidSelectCellDelegate {

    func didSelect(_ cellDescriptor: CollectionCellDescriptable, sectionDescriptor: CollectionSectionDescriptable, indexPath: IndexPath) {
        switch (cellDescriptor, cellDescriptor.adapter) {
            
        case (is ColorDescriptor, _):
            let result = demoDatas.update {
                demoDatas.remove(cells: [cellDescriptor])
            }
            collectionView.performUpdates(with: result)
        
        case (_, let adapter as TitleAdapter):
            
            var result:UpdateCollectionResult!
            
            if let expandedCells = expanded[cellDescriptor.indexPath] {
                result = demoDatas.collapse(cells: expandedCells)
                expanded[cellDescriptor.indexPath] = nil
            } else {
                result = demoDatas.expand(titleDescriptor: cellDescriptor, color: adapter.color)
                expanded[cellDescriptor.indexPath] = result.insertedCellDescriptors
            }
            
            collectionView.performUpdates(with: result)
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
            let result = demoDatas.update {
                demoDatas.reload(cells: [cell])
            }
            collectionView.performUpdates(with: result)
            
        } else {
            let result = demoDatas.update {
                demoDatas.reload(sections: [section])
            }
            collectionView.performUpdates(with: result)
        }
    }
}
