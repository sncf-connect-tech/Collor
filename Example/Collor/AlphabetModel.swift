//
//  AlphabetModel.swift
//  Collor_Example
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class AlphabetModel {
    
    struct Letter {
        var key: String
        var countries: [String]
    }
    
    static let originalvalues: [Letter] = [
        Letter(key: "A", countries: ["Afghanistan",
                                    "Albania",
                                    "Algeria",
                                    "Andorra",
                                    "Angola",
                                    "Antigua and Barbuda",
                                    "Argentina"]),
        Letter(key: "B", countries: ["Bahrain",
                                    "Bangladesh",
                                    "Barbados",
                                    "Belarus",
                                    "Belgium",
                                    "Belize",
                                    "Benin"]),
        Letter(key: "C", countries: ["Cambodia",
                                    "Cameroon",
                                    "Canada",
                                    "Cabo Verde",
                                    "Central African Republic",
                                    "Chad",
                                    "Chile",
                                    "China",
                                    "Colombia"]),
        Letter(key: "D", countries: ["Denmar",
                                    "Djibout",
                                    "Dominic",
                                    "Dominican Republic"])
    ]
    var values: [Letter] = [AlphabetModel.originalvalues[0]]
    
    func add() {
        if values.count == AlphabetModel.originalvalues.count {
            return
        }
        let index = values.indices.last!
        values.append( AlphabetModel.originalvalues[index + 1] )
    }
    
    func reset() {
        values = [AlphabetModel.originalvalues[0]]
    }
    
    func shake() {
        values = values.shuffled()
    }
}
