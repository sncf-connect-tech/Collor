//
//  Diffable.swift
//  Pods
//
//  Created by Guihal Gwenn on 08/09/2017.
//
//

import Foundation

public protocol Diffable {
    func isEqual(to other: Diffable?) -> Bool
}

public extension Diffable where Self: Equatable {

    func isEqual(to other: Diffable?) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}
