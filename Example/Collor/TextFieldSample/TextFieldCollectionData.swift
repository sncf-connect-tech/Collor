//
//  TextFieldCollectionData.swift
//  Collor_Example
//
//  Created by Deffrasnes Ghislain on 07/05/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class TextFieldCollectionData: CollectionData {

    var numberOfCell = 2

    var sectionToReload: CollectionSectionDescribable?

    override func reloadData() {
        super.reloadData()

        let section1 = TextFieldSectionDescriptor().uid("section1_id").reloadSection { cells in
            let cellDescriptor = TextFieldDescriptor(adapter: TextFieldAdapter()).uid("cell1_id")
            cells.append(cellDescriptor)
        }
        sections.append(section1)

        let section2 = TextFieldSectionDescriptor().uid("section2_id").reloadSection { [weak self] cells in
            guard let self = self else {
                return
            }

            if self.numberOfCell == 2 {
                let cellDescriptor = TextFieldDescriptor(adapter: TextFieldAdapter()).uid("cell2_id")
                cells.append(cellDescriptor)
            }

            self.numberOfCell = self.numberOfCell == 2 ? 1 : 2
        }
        sections.append(section2)
        self.sectionToReload = section2
    }

}
