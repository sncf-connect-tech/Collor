//
//  Diffable.swift
//  Pods
//
//  Created by Guihal Gwenn on 08/09/2017.
//
//

import Foundation

public protocol Diffable {
    func isEqual(to other:Diffable?) -> Bool
}
