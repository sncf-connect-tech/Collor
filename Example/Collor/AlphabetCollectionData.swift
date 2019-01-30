//
//  AlphabetCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class AlphabetCollectionData : CollectionData {
    
    let model = AlphabetModel()
    
    override func reloadData() {
        super.reloadData()
        
        model.values.forEach { (letter, countries) in
            let section = AlphabetSectionDescriptorSectionDescriptor().reload { builder in
                countries.forEach { country in
                    let cell = AlphabetDescriptor(adapter: AlphabetAdapter(country: country))
                    builder.cells.append(cell)
                }
                
                // supplementaryView
                let letterAdapter = LetterAdapter(letter: letter)
                let letterDescriptor = LetterCollectionReusableViewDescriptor(adapter: letterAdapter)
                builder.add(supplementaryView: letterDescriptor, kind: "letter")
            }
            sections.append(section)
        }
    }
}

