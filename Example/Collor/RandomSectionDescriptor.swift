//
//  RandomSectionDescriptor.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

class RandomSectionDescriptor: CollectionSectionDescribable, SectionDecorable {
    var hasBackground: Bool = true
    
    func sectionInset(_ bounds:CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
