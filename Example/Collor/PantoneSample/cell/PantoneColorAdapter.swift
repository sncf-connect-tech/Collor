//
//  PantoneColorAdapter.swift
//  Collor
//
//  Created by Guihal Gwenn on 08/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

struct PantoneColorAdapter: CollectionAdapter {

    let hexaColor:Int
    
    let color:UIColor
    
    init(hexaColor:Int) {
        self.hexaColor = hexaColor
        color = UIColor(rgb: hexaColor)
    }
}


// from https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
