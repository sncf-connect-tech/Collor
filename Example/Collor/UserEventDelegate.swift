//
//  UserEventDelegate.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/03/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Collor
import Foundation

enum UserEvent {
    case buttonTap
}

protocol UserEventDelegate : CollectionUserEventDelegate {
    func onUserEvent(_ event:UserEvent, cell:UICollectionViewCell)
}
