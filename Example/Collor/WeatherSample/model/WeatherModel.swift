//
//  WeatherModel.swift
//  BABA
//
//  Created by Guihal Gwenn on 16/02/17.
//  Copyright © 2017 Guihal Gwenn. All rights reserved.
//

import UIKit

struct WeatherDay : Equatable {
    let date:Date
    let temperature:Float
    let pressure:Float
    let humidity:Float
    let weatherIcon:String
    
    public static func ==(lhs: WeatherDay, rhs: WeatherDay) -> Bool {
        return lhs.date == rhs.date
    }
}

final class WeatherModel {
    
    let weatherDays:[WeatherDay]
    let cityName:String
    
    init?( json:[String:Any] ) {
        
        // city name
        guard let cityData = json["city"] as? [String:Any], let cityName = cityData["name"] as? String
        else {
            return nil
        }
        
        self.cityName = cityName
        
        // weather days
        guard let daysList = json["list"] as? [[String:Any]] else {
            return nil
        }
        
        weatherDays = daysList.compactMap { (dayData) in
            guard let timeStamp = dayData["dt"] as? Double,
                let tempData = dayData["temp"] as? [String:Any],
                let temp = tempData["day"] as? Float,
                let pressure = dayData["pressure"] as? Float,
                let humidity = dayData["humidity"] as? Float,
                let weatherData = dayData["weather"] as? [[String:Any]],
                let icon = weatherData.first?["icon"] as? String else {
                    return nil
            }
            return WeatherDay(date: Date(timeIntervalSince1970: TimeInterval(timeStamp)),
                              temperature: temp, pressure: pressure, humidity: humidity,
                              weatherIcon: icon)
        }
    }
}
