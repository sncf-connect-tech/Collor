//
//  MenuItemAdapter.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import UIKit
import Collor

struct MenuItemAdapter: CollectionAdapter {

    let example:Example
    
    let label:String
    
    init(example:Example) {
        self.example = example
        label = example.title
    }

}
