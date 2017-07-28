//
//  WeatherViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Collor

final class WeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)
    
    private let weatherService = WeatherService()
    let collectionDatas = WeatherCollectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(collectionView: collectionView, with: collectionDatas, and: collectionViewDelegate, and: collectionViewDatasource)
        
        weatherService.get16DaysWeather { [weak self] response in
            switch response {
            case .success(let data):
                self?.collectionDatas.reload(model: data)
                self?.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewController : CollectionDidSelectCellDelegate {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath) {
        switch (cellDescriptor, cellDescriptor.getAdapter()) {
        case (is WeatherDayDescriptor, let adapter as WeatherDayAdapter):
            if let index = collectionDatas.expandedSections.index(of: adapter.day) {
                collectionDatas.expandedSections.remove(at: index)
            } else {
                collectionDatas.expandedSections.append(adapter.day)
            }
            let result = collectionDatas.update{ updater in
                updater.reloadData()
            }
            collectionView.performUpdates(with: result)
        default:
            break
        }
    }
}

extension WeatherViewController : UserEventDelegate {
    func onUserEvent(_ event: UserEvent, cell: UICollectionViewCell) {}
}
