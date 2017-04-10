//
//  CollectionAdapter.swift
//  VSC
//
//  Created by Guihal Gwenn on 06/10/16.
//  Copyright © 2016 VSCT. All rights reserved.
//
import Foundation

public protocol CollectionDidSelectCellDelegate : NSObjectProtocol {
    func didSelect(_ cellDescriptor: CollectionCellDescribable, sectionDescriptor: CollectionSectionDescribable, indexPath: IndexPath)
}
