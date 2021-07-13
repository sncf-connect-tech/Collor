//
//  TextFieldViewController.swift
//  Collor_Example
//
//  Created by Deffrasnes Ghislain on 07/05/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Collor


class TextFieldViewController: UIViewController {

    fileprivate(set) lazy var collectionViewDelegate: CollectionDelegate = CollectionDelegate(delegate: self)
    fileprivate(set) lazy var collectionViewDatasource: CollectionDataSource = CollectionDataSource(delegate: self)

    private var collectionView: UICollectionView!
    private let collectionData = TextFieldCollectionData()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Text fields"

        let collectionView = setupCollectionView()

        bind(collectionView: collectionView,
             with: collectionData,
             and: collectionViewDelegate,
             and: collectionViewDatasource)
        self.collectionView = collectionView

        let crashingButton = UIBarButtonItem(barButtonSystemItem: .action,
                                             target: self,
                                             action: #selector(applyCollorDiffCrashing))
        let fixedButton = UIBarButtonItem(barButtonSystemItem: .play,
                                          target: self,
                                          action: #selector(applyCollorDiffFixed))
        navigationItem.rightBarButtonItems = [fixedButton, crashingButton]
    }

    private func setupCollectionView() -> UICollectionView {
        // Layout
        // If you set here another custom layout,
        // you may trigger the crash that happens
        // when the dataSource modifications are not done
        // inside the block given to `UICollectionView.performBatchUpdates`.
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: CGRect.zero,  // Auto-layout manage size
            collectionViewLayout: layout)
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoPinEdgesToSuperview()

        collectionView.alwaysBounceVertical = true

        return collectionView
    }

    @objc
    private func applyCollorDiffCrashing() {
        let updateResult = collectionData.update { updater in
            if let sectionToReload = collectionData.sectionToReload {
                updater.diff(sections: [sectionToReload])
            }
        }

        collectionView.performUpdates(with: updateResult)
    }

    @objc
    private func applyCollorDiffFixed() {
        collectionView.performCollorDiff({ [weak self] in
            guard let self = self else {
                return nil
            }

            let updateResult = self.collectionData.update { updater in
                if let sectionToReload = self.collectionData.sectionToReload {
                    updater.diff(sections: [sectionToReload])
                }
            }

            return updateResult
        })
    }

}

extension TextFieldViewController: CollectionDidSelectCellDelegate {

    func didSelect(_ cellDescriptor: CollectionCellDescribable,
                   sectionDescriptor: CollectionSectionDescribable,
                   indexPath: IndexPath) {
        
    }

}

extension TextFieldViewController: CollectionUserEventDelegate {

}


extension TextFieldViewController: TextFieldCellDelegate {

    func supplyDelegate() -> RealTextFieldCellDelegate {
        self
    }

}


extension TextFieldViewController: RealTextFieldCellDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        // This `async` call is another condition to trigger the crash that happens
        // when the dataSource modifications are not done
        // inside the block given to `UICollectionView.performBatchUpdates`.

        DispatchQueue.main.async { [weak self] in
            self?.applyCollorDiffCrashing()
//            self?.applyCollorDiffFixed()
        }
    }

}
