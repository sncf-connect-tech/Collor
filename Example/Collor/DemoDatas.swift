//
//  DemoDatas.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Collor
import UIKit
import Foundation

final class DemoDatas: CollectionDatas {
    
    enum Color {
        case yellow
        case green
        case blue
        
        func getColors() -> [Int] {
            switch self {
            case .yellow:
                return [0xF3ED86,0xF5EC62,0xFAE600,0xCAAD00]
            case .green:
                return [0xBCE18D,0xA4D867,0x62BD19,0x4FA600]
            case .blue:
                return [0x94A1E2,0xA1BDEA,0x547ED9,0x7973C2]
            }
        }
        
        func getTitle() -> String {
            switch self {
            case .blue:
                return "Blue"
            case .green:
                return  "Green"
            case .yellow:
                return  "Yellow"
            }
        }
    }
    
    enum Action {
        case addSection
        case removeSection
    }
    
    var expanded:Color?
    
    override func reloadData() {
        super.reloadData()
        
        sections.removeAll()
        
        let actionSection = MainColorSectionDescriptor().uid("actionSection")
        
        let addSectionCell = ActionDescriptor(adapter: ActionAdapter(action: .addSection) ).uid("addSectionCell")
        actionSection.cells.append(addSectionCell)
        let removeSectionCell = ActionDescriptor(adapter: ActionAdapter(action: .removeSection)).uid("removeSectionCell")
        actionSection.cells.append(removeSectionCell)
        let buttonCell = UserEventDescriptor().uid("buttonCell")
        actionSection.cells.append(buttonCell)
        sections.append(actionSection)
        
        let yellowSection = MainColorSectionDescriptor().uid("yellowSection")
        let yellowTitle = TitleDescriptor(adapter: TitleAdapter(color: .yellow)).uid("yellowTitle")
        yellowSection.cells.append(yellowTitle)
        if expanded == .yellow {
            
            let cells:[CollectionCellDescribable] = Color.yellow.getColors().map {
                ColorDescriptor(adapter: ColorAdapter(hexaColor: $0)).uid("yellow\($0)")
            }
            yellowSection.cells.append(contentsOf: cells)
            
        }
        yellowSection.cells.append( ColorDescriptor(adapter: ColorAdapter(hexaColor: 0xFF0000)).uid("red") )
        sections.append(yellowSection)
        
        let greenSection = MainColorSectionDescriptor().uid("greenSection")
        let greenTitle = TitleDescriptor(adapter: TitleAdapter(color: .green)).uid("greenTitle")
        greenSection.cells.append(greenTitle)
        if expanded == .green {
            
            let cells:[CollectionCellDescribable] = Color.green.getColors().map {
                ColorDescriptor(adapter: ColorAdapter(hexaColor: $0)).uid("green\($0)")
            }
            greenSection.cells.append(contentsOf: cells)
            
        }
        sections.append(greenSection)
        
        let blueSection = MainColorSectionDescriptor().uid("blueSection")
        let blueTitle = TitleDescriptor(adapter: TitleAdapter(color: .blue)).uid("blueTitle")
        blueSection.cells.append(blueTitle)
        if expanded == .blue {
            
            let cells:[CollectionCellDescribable] = Color.blue.getColors().map {
                ColorDescriptor(adapter: ColorAdapter(hexaColor: $0)).uid("blue\($0)")
            }
            blueSection.cells.append(contentsOf: cells)
            
        }
        sections.append(blueSection)
    }
    
    func expand(titleDescriptor:CollectionCellDescribable, color:Color) -> UpdateCollectionResult {
        
        let newCells:[CollectionCellDescribable] = color.getColors().map {
            ColorDescriptor(adapter: ColorAdapter(hexaColor: $0))
        }
        
        let result = update { updater in
            updater.append(cells: newCells, after: titleDescriptor)
        }
        return result
    }
    
    func collapse(cells:[CollectionCellDescribable]) -> UpdateCollectionResult {
        let result = update { updater in
            updater.remove(cells: cells)
        }
        return result
    }
    
    func addSection() -> UpdateCollectionResult {
        
        let blueSection = MainColorSectionDescriptor()
        let blueTitle = TitleDescriptor(adapter: TitleAdapter(color: .blue))
        blueSection.cells.append(blueTitle)
        
        let result = update { updater in
            let last = sections.last
            updater.append(sections: [blueSection], after: last!)
        }
        
        return result
    }
    
    func removeRandomSection() -> UpdateCollectionResult? {
        
        if sections.count <= 1 {
            return nil
        }
        
        let randomIndex = 1 + Int(arc4random_uniform( UInt32(sections.count) - 1))
        let sectionToRemove = sections[randomIndex]
        let result = update { updater in
            updater.remove(sections: [sectionToRemove])
        }
        
        return result
        
    }
}
