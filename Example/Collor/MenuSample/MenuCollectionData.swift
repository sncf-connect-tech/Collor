//
//  MenuCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 14/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

final class MenuCollectionData : CollectionData {
    
    let examples:[Example]
    
    
    init(examples:[Example]) {
        self.examples = examples
        super.init()
    }
    
    
    override func reloadData() {
        super.reloadData()
        
        let section = MenuSectionDescriptor().reloadSection { cells in
            self.examples.forEach {
                cells.append( MenuItemDescriptor(adapter: MenuItemAdapter(example: $0 ) ))
            }
        }
        sections.append(section)
    }
}

