//
//  CollectionCellAdaptable.swift
//  Pods
//
//  Created by Guihal Gwenn on 16/03/17.
//
//

import Foundation

public protocol CollectionCellAdaptable : NSObjectProtocol {
    func update(with adapter: CollectionAdapter) -> Void
    func set(delegate delegate:CollectionUserEventDelegate) -> Void
}

// default implementation of CollectionCellAdaptable
public extension CollectionCellAdaptable {
    func set(delegate delegate:CollectionUserEventDelegate) {}
}
