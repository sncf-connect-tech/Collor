//
//  TitleAdapter.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

struct TitleAdapter: VSCollectionAdapter {

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
