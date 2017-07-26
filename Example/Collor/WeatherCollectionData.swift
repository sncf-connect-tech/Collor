//
//  WeatherCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class WeatherCollectionData : CollectionDatas {
    
    var weatherModel:WeatherModel?
    
    func reload(model:WeatherModel) {
        weatherModel = model
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let weatherModel = self.weatherModel else {
            return
        }
        
        
    }
}
