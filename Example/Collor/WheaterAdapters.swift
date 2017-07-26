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
    var cellHeight: CGFloat = 50
    
    init(cityName:String) {
        self.title = NSAttributedString(string: cityName, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ])
    }
}

struct WeatherTemperatureAdapter: WeatherLabelAdapterProtocol {
    
    var label:NSAttributedString
    var height: CGFloat?
    
    init(day:WeatherDay) {
        
        let title = NSAttributedString(string: "Temperature: ", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ])
        let temperature = NSAttributedString(string: "\(day.temperature)°", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ])
        let label = NSMutableAttributedString(attributedString: title)
        label.append(temperature)
        self.label = label
    }
}

struct WeatherPressureAdapter: WeatherLabelAdapterProtocol {
    
    var label:NSAttributedString
    var height: CGFloat?
    
    init(day:WeatherDay) {
        
        let title = NSAttributedString(string: "Pressure: ", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ])
        let temperature = NSAttributedString(string: "\(day.pressure)", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
            ])
        let label = NSMutableAttributedString(attributedString: title)
        label.append(temperature)
        self.label = label
    }
}
