//
//  WeatherDayAdapter.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

struct WeatherDayAdapter: CollectionAdapter {

    let iconURL:URL
    let date:NSAttributedString
    let day:WeatherDay
    
    static let dateFormatter:DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE d MMMM"
        return df
    }()
    
    init(day:WeatherDay) {
        
        self.day = day
        
        iconURL = URL(string: "https://openweathermap.org/img/w/" + day.weatherIcon + ".png")!
        let dateString = WeatherDayAdapter.dateFormatter.string(from: day.date)
        date = NSAttributedString(string: dateString, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.black
        ])
    }

}
