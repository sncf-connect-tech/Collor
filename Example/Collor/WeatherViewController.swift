//
//  WeatherViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor

final class WeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: nil)
    
    private let weatherService = WeatherService()
    let collectionData = WeatherCollectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"
        
        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
        collectionView.collectionViewLayout = WhiteSectionLayout(datas: collectionData)
        
        weatherService.get16DaysWeather { [weak self] response in
            switch response {
            case .success(let data):
                self?.collectionData.reload(model: data)
                self?.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {
        switch (sectionDescriptor) {
        case (let sectionDescriptor as WeatherSectionDescriptor):
            sectionDescriptor.isExpanded = !sectionDescriptor.isExpanded
            let result = collectionData.update{ updater in
                updater.diff(sections: [sectionDescriptor])
            }
            collectionView.performUpdates(with: result)
        default:
            break
        }
    }
}
