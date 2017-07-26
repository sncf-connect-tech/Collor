//
//  WheaterAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

struct WeatherHeaderAdapter: WeatherTitleAdapterProtocol {
    
    let title: NSAttributedString
    var lineColor: UIColor = .black
    
    init(cityName:String) {
        self.title = NSAttributedString(string: cityName, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ])
    }
    
}
