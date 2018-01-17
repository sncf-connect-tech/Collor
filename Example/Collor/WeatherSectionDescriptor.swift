//
//  WeatherSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 26/07/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

final class WeatherSectionDescriptor : CollectionSectionDescribable, SectionDecorable {
    
    let hasBackground:Bool
    var isExpanded:Bool = false
    
    convenience init() {
        self.init(hasBackground: true)
    }
    
    init(hasBackground:Bool) {
        self.hasBackground = hasBackground
    }
    
    func sectionInset(_ collectionViewBounds:CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
}
