//
//  DemoDatas.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import VSCollectionDescriptor
import UIKit

class DemoDatas: VSCollectionDatas {
    
    let yellowColors = [0xF3ED86,0xF5EC62,0xFAE600,0xCAAD00]
    let greenColors = [0xBCE18D,0xA4D867,0x62BD19,0x4FA600]
    let blueColors = [0x94A1E2,0xA1BDEA,0x547ED9,0x7973C2]
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        let yellowSection = MainColorSectionDescriptor()
        let yellowTitle = TitleDescriptor(title: "Yellow")
        yellowSection.cells.append(yellowTitle)
        sections.append(yellowSection)
        
        let greenSection = MainColorSectionDescriptor()
        let greenTitle = TitleDescriptor(title: "Green")
        greenSection.cells.append(greenTitle)
        sections.append(greenSection)
        
        let blueSection = MainColorSectionDescriptor()
        let blueTitle = TitleDescriptor(title: "Blue")
        blueSection.cells.append(blueTitle)
        sections.append(blueSection)
    }
    
    func green(titleDescriptor:VSCollectionCellDescriptor) {
        let yellowCells:[VSCollectionCellDescriptor] = yellowColors.map {
            ColorDescriptor(hexaColor: $0)
        }
        
        beginUpdate()
        append(cells: yellowCells, after: titleDescriptor)
        let result = endUpdate()
        
        collectionView?.performBatchUpdates({ 
            self.collectionView?.insertItems(at: result.appendedIndexPaths)
        }, completion: nil)
        
    }
}
