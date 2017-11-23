//
//  WeatherStyle.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import UIKit

struct WeatherStyle {
    
    struct WeatherProperty {
        
        static func property(key:String, value:String) -> NSAttributedString {
            let keyAttString = NSAttributedString(string: key, attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                NSAttributedStringKey.foregroundColor: UIColor.black
                ])
            let valueAttString = NSAttributedString(string: value, attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedStringKey.foregroundColor: UIColor.black
                ])
            let result = NSMutableAttributedString(attributedString: keyAttString)
            result.append(valueAttString)
            return result
        }
    }
}
