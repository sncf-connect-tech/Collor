//
//  CollectionAdapter.swift
//  VSC
//
//  Created by Guihal Gwenn on 06/10/16.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//
import Foundation

public protocol CollectionDidSelectCellDelegate : NSObjectProtocol {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath)
}
