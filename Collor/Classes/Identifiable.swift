//
//  Identifiable.swift
//  Pods
//
//  Created by Guihal Gwenn on 15/06/2017.
//
//

import Foundation

private struct AssociatedKeys {
    static var UniqueIdentifier = "collor_UniqueIdentifier"
}

public protocol Identifiable: class {
    
}

public extension Identifiable {
    func uid(_ uid:String) -> Self {
        _uid = uid
        return self
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
