//
//  Identifiable.swift
//  Collor
//
//  Created by Guihal Gwenn on 15/06/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation

private struct AssociatedKeys {
    static var UniqueIdentifier = "collor_UniqueIdentifier"
    static var Value = "collor_Value"
}

public protocol Identifiable: class {
    
}

public extension Identifiable {
    @discardableResult func uid(_ uid:String) -> Self {
        _uid = uid
        return self
    }
    func uid() -> String? {
        return _uid
    }
}

extension Identifiable {
    var _uid: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UniqueIdentifier) as? String
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.UniqueIdentifier, newValue as String?, .OBJC_ASSOCIATION_COPY)
        }
    }
}

//func ==<T: Identifiable>(lhs: T, rhs: T) -> Bool {
//    return lhs._uid == rhs._uid
//}
