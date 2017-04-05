//
//  TitleAdapter.swift
//  Collor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Collor
import Foundation

struct TitleAdapter: CollectionAdapter {

    let color:DemoDatas.Color
    let title:String
    
    init(color:DemoDatas.Color) {
        
        self.color = color
        
        switch color {
        case .blue:
            title = "Blue"
        case .green:
            title = "Green"
        case .yellow:
            title = "Yellow"
        }
    }

}
