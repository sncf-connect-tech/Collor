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
        
        demoDatas.collectionView = collectionView
        demoDatas.reloadData()
    }
}

extension ViewController : VSCollectionDidSelectCellDelegate {
    func didSelectCell(_ cellDescriptor: VSCollectionCellDescriptor, sectionDescriptor: VSCollectionSectionDescriptor, indexPath: IndexPath) {
        demoDatas.green(titleDescriptor: cellDescriptor)
    }
}

extension ViewController : VSCollectionUserEventDelegate {
    
}
