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
        
        model.values.forEach { letter in
            let section = AlphabetSectionDescriptorSectionDescriptor().uid(letter.key).reload { builder in
                letter.countries.forEach { country in
                    let cell = AlphabetDescriptor(adapter: AlphabetAdapter(country: country)).uid(country)
                    builder.cells.append(cell)
                }
                
                // supplementaryView
                let letterAdapter = LetterAdapter(letter: letter.key)
                let letterDescriptor = LetterCollectionReusableViewDescriptor(adapter: letterAdapter)
                builder.add(supplementaryView: letterDescriptor, kind: "letter")
            }
            sections.append(section)
        }
    }
    
    func add() -> UpdateCollectionResult {
        model.add()
        return diff()
    }
    
    func shake() -> UpdateCollectionResult {
        model.shake()
        return diff()
    }
    
    func reset() -> UpdateCollectionResult {
        model.reset()
        return diff()
    }
    
    func diff() -> UpdateCollectionResult {
        return update { (updater) in
            updater.diff()
        }
    }
}

