//
//  MenuViewController.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import UIKit
import Collor

// model
struct Example {
    let title:String
    let controllerClass:UIViewController.Type
}

// user event
enum MenuUserEvent {
    case itemTap(Example)
}

protocol MenuUserEventDelegate : CollectionUserEventDelegate {
    func onUserEvent(userEvent:MenuUserEvent)
}

// controller
class MenuViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: nil)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)

    let examples:[Example] = [Example(title: "Panton", controllerClass: PantoneViewController.self),
                              Example(title: "Random", controllerClass: RandomViewController.self),
                              Example(title: "Weather", controllerClass: WeatherViewController.self),
                              Example(title: "Real Time", controllerClass: RealTimeViewController.self)]
    
    
    lazy var collectionData:MenuCollectionData = MenuCollectionData(examples: self.examples)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        
        bind(collectionView: collectionView, with: collectionData, and: collectionViewDelegate, and: collectionViewDatasource)
        collectionViewDelegate.forwardingDelegate = self
    }
}

extension MenuViewController : MenuUserEventDelegate {
    func onUserEvent(userEvent: MenuUserEvent) {
        switch userEvent {
        case .itemTap(let example):
            let controller = example.controllerClass.init()
            navigationController?.pushViewController(controller, animated: true)
            break
        }
    }
}

extension MenuViewController : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
    }
}

