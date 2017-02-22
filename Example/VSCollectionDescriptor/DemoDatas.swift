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
    
    enum Color {
        case yellow
        case green
        case blue
    }
    
    let yellowColors = [0xF3ED86,0xF5EC62,0xFAE600,0xCAAD00]
    let greenColors = [0xBCE18D,0xA4D867,0x62BD19,0x4FA600]
    let blueColors = [0x94A1E2,0xA1BDEA,0x547ED9,0x7973C2]
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        let yellowSection = MainColorSectionDescriptor()
        let yellowTitle = TitleDescriptor(color: .yellow)
        yellowSection.cells.append(yellowTitle)
        sections.append(yellowSection)
        
        let greenSection = MainColorSectionDescriptor()
        let greenTitle = TitleDescriptor(color: .green)
        greenSection.cells.append(greenTitle)
        sections.append(greenSection)
        
        let blueSection = MainColorSectionDescriptor()
        let blueTitle = TitleDescriptor(color: .blue)
        blueSection.cells.append(blueTitle)
        sections.append(blueSection)
    }
    
    func expand(titleDescriptor:VSCollectionCellDescriptor, color:Color) -> UpdateCollectionResult {
        
        var newColors:[Int]!
        switch color {
        case .green:
            newColors = greenColors
        case .yellow:
            newColors = yellowColors
        case .blue:
            newColors = blueColors
        }
        
        let newCells:[VSCollectionCellDescriptor] = newColors.map {
            ColorDescriptor(hexaColor: $0)
        }
        
        beginUpdate()
        append(cells: newCells, after: titleDescriptor)
        let result = endUpdate()
        
        return result
    }
}
