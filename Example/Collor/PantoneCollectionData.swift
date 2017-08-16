//
//  PantoneCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 08/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class PantoneCollectionData : CollectionData {
    
    var model: MetallicPantone?
    
    func reload(model:MetallicPantone) {
        self.model = model
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let model = model else {
            return
        }
        
        let section = PantoneSectionDescriptor().reloadSection { (cells) in
            model.used.forEach({ hexaColor in
                let colorCellDescriptor = PantoneColorDescriptor(adapter: PantoneColorAdapter(hexaColor: hexaColor))
                cells.append(colorCellDescriptor)
            })
        }
        sections.append(section)
    }
}
