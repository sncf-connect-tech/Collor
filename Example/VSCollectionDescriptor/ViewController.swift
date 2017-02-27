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
    
    fileprivate(set) lazy var collectionViewDelegate: VSCollectionDelegate = VSCollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: VSCollectionDataSource = VSCollectionDataSource(delegate: self)
    
    var expanded = [IndexPath:[VSCollectionCellDescriptor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demo App"
        
        setupCollectionView();
    }
    
    func setupCollectionView() {
        
        collectionViewDelegate.collectionDatas = demoDatas
        collectionViewDatasource.collectionDatas = demoDatas
        
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDatasource
        
        collectionView.backgroundColor = UIColor.clear
        
    }
}

extension ViewController : VSCollectionDidSelectCellDelegate {
    func didSelectCell(_ cellDescriptor: VSCollectionCellDescriptor, sectionDescriptor: VSCollectionSectionDescriptor, indexPath: IndexPath) {
        switch (cellDescriptor, cellDescriptor.adapter) {
            
        case (is ColorDescriptor, _):
            let result = demoDatas.update {
                demoDatas.remove(cells: [cellDescriptor])
            }
            
            collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: result.removedIndexPaths)
            }, completion: nil)
        
        case (_, let adapter as TitleAdapter):
            
            var result:UpdateCollectionResult!
            
            if let expandedCells = expanded[cellDescriptor.indexPath] {
                result = demoDatas.collapse(cells: expandedCells)
                expanded[cellDescriptor.indexPath] = nil
            } else {
                result = demoDatas.expand(titleDescriptor: cellDescriptor, color: adapter.color)
                expanded[cellDescriptor.indexPath] = result.appendedCellDescriptors
            }
            
            collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: result.removedIndexPaths)
                self.collectionView?.insertItems(at: result.appendedIndexPaths)
            }, completion: nil)
            
        case (_, let adapter as ActionAdapter):
            switch adapter.action {
            case .addSection:
                
                let result = demoDatas.addSection()
                
                collectionView?.performBatchUpdates({
                    self.collectionView.insertSections(result.appenedSectionsIndexSet)
                }, completion: nil)
            case .removeSection:
                if let result = demoDatas.removeRandomSection() {
                    collectionView?.performBatchUpdates({
                        self.collectionView.deleteSections(result.removedSectionsIndexSet)
                    }, completion: nil)
                }
            }
            
        default:
            break
        }
    }
}

extension ViewController : VSCollectionUserEventDelegate {
    
}
