//
//  WeatherService.swift
//  BABA
//
//  Created by Guihal Gwenn on 16/02/17.
//  Copyright © 2017 Guihal Gwenn. All rights reserved.
//

import Alamofire
import UIKit

class WeatherService: NSObject {
    
    enum WheatherError : Error {
        case unknowError
        case networkError
    }
    
    enum WeatherResponse {
        case success(WeatherModel)
        case error(WheatherError)
    }

    func get16DaysWeather(completion: @escaping (WeatherResponse)->Void ) {
        
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily?id=6455259&appid=92b25fae9369a3cf06456eda297b162a&units=metric"
        
        Alamofire.request(url).responseJSON { response in
            
            switch (response.result) {
            case .success(let data):
                if let dictionary = data as? [String:Any], let weatherModel = WeatherModel(json: dictionary) {
                    completion( .success(weatherModel) )
                } else {
                    completion( .error( .unknowError ) )
                }
                
            case .failure( _):
                completion( .error( .networkError ) )
            }
        }
    }
}
