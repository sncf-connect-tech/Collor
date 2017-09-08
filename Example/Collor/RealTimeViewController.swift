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

    private let realTimeService = RealTimeService()
    let collectionData = RealTimeCollectionData()
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Real Time"
        
        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
        collectionView.collectionViewLayout = RealTimeLayout(datas: collectionData)
        
        //fetch()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(RealTimeViewController.fetch), userInfo: nil, repeats: true)
        timer!.fire()
        
        //fetch()
    }
    
    func fetch() {
        realTimeService.getRecentTweets { [weak self] response in
            switch response {
            case .success(let data):
                self?.collectionData.update(model: data)
                let result = self?.collectionData.update { updater in
                    updater.diff()
                }
                if let result = result {
                    self?.collectionView.performUpdates(with: result)
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

extension RealTimeViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {}
}

extension RealTimeViewController : CollectionUserEventDelegate {
    
}
