//
//  WeatherCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

final class WeatherCollectionData : CollectionData {
    
    var weatherModel:WeatherModel?
    
    func reload(model:WeatherModel) {
        weatherModel = model
        reloadData()
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let weatherModel = self.weatherModel else {
            return
        }
        
        let titleSection = WeatherSectionDescriptor(hasBackground: false).reloadSection { cells in
            let header = TitleDescriptor(adapter:  WeatherHeaderAdapter(cityName: weatherModel.cityName ))
            cells.append(header)
        }
        sections.append(titleSection)
        
        let daySections = weatherModel.weatherDays.map { day -> CollectionSectionDescribable in
            let section = WeatherSectionDescriptor()
            section.reloadSection { cells in
                
                let dayCellDescriptor = WeatherDayDescriptor(adapter: WeatherDayAdapter(day: day) ).uid("day")
                cells.append( dayCellDescriptor )
                
                if section.isExpanded {
                    
                    let temperatureCellDescriptor = LabelDescriptor(adapter: WeatherTemperatureAdapter(day: day) ).uid("temp")
                    cells.append( temperatureCellDescriptor )
                    
                    let pressureCellDescriptor = LabelDescriptor(adapter: WeatherPressureAdapter(day: day) ).uid("pressure")
                    cells.append( pressureCellDescriptor )
                }
            }
            return section
        }
        sections.append(contentsOf: daySections)
    }
}
