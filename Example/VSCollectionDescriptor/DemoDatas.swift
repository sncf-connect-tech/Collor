//
//  DemoDatas.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import VSCollectionDescriptor
import UIKit
import Foundation

class DemoDatas: CollectionDatas {
    
    enum Color {
        case yellow
        case green
        case blue
    }
    
    enum Action {
        case addSection
        case removeSection
    }
    
    let yellowColors = [0xF3ED86,0xF5EC62,0xFAE600,0xCAAD00]
    let greenColors = [0xBCE18D,0xA4D867,0x62BD19,0x4FA600]
    let blueColors = [0x94A1E2,0xA1BDEA,0x547ED9,0x7973C2]
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        let actionSection = MainColorSectionDescriptor()
        let addSection = ActionDescriptor(action: .addSection)
        actionSection.cells.append(addSection)
        let removeSection = ActionDescriptor(action: .removeSection)
        actionSection.cells.append(removeSection)
        sections.append(actionSection)
        
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
    
    func expand(titleDescriptor:CollectionCellDescriptable, color:Color) -> UpdateCollectionResult {
        
        var newColors:[Int]!
        switch color {
        case .green:
            newColors = greenColors
        case .yellow:
            newColors = yellowColors
        case .blue:
            newColors = blueColors
        }
        
        let newCells:[CollectionCellDescriptable] = newColors.map {
            ColorDescriptor(hexaColor: $0)
        }
        
        let result = update {
            append(cells: newCells, after: titleDescriptor)
        }
        return result
    }
    
    func collapse(cells:[CollectionCellDescriptable]) -> UpdateCollectionResult {
        let result = update {
            remove(cells: cells)
        }
        return result
    }
    
    func addSection() -> UpdateCollectionResult {
        
        let blueSection = MainColorSectionDescriptor()
        let blueTitle = TitleDescriptor(color: .blue)
        blueSection.cells.append(blueTitle)
        
        let result = update {
            let last = sections.last
            append(sections: [blueSection], after: last!)
        }
        
        return result
    }
    
    func removeRandomSection() -> UpdateCollectionResult? {
        
        if sections.count <= 1 {
            return nil
        }
        
        let randomIndex = 1 + Int(arc4random_uniform( UInt32(sections.count) - 1))
        let sectionToRemove = sections[randomIndex]
        let result = update {
            remove(sections: [sectionToRemove])
        }
        
        return result
        
    }
}
