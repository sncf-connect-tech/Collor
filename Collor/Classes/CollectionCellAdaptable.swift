//
//  CollectionCellAdaptable.swift
//  Collor
//
//  Created by Guihal Gwenn on 16/03/17.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation

public protocol CollectionCellAdaptable {
    func update(with adapter: CollectionAdapter) -> Void
    func set(delegate:CollectionUserEventDelegate?) -> Void
}

// default implementation of CollectionCellAdaptable
public extension CollectionCellAdaptable {
    func set(delegate:CollectionUserEventDelegate?) {}
}

public protocol CollectionSupplementaryViewAdaptable {
    func update(with adapter: CollectionAdapter) -> Void
}
