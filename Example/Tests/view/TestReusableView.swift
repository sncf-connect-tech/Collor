//
//  TestReusableView.swift
//  Collor_Example
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor

class TestReusableViewDescriptor : CollectionSupplementaryViewDescribable {
    var identifier: String = "TestReusableView"
    var className: String = "TestReusableView"
    
    let adapter: TestSuppViewAdapter
    
    init(adapter: TestSuppViewAdapter) {
        self.adapter = adapter
    }
    
    func getAdapter() -> CollectionAdapter {
        return adapter
    }
    
    func frame(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGRect {
        return CGRect(x: 0, y: 0, width: 80, height: 80)
    }
}

struct TestSuppViewAdapter: CollectionAdapter {
}

class TestReusableView: UICollectionReusableView, CollectionSupplementaryViewAdaptable {
    func update(with adapter: CollectionAdapter) {
    }
}
