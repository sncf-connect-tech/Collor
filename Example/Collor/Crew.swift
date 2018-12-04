//
//  Crew.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation

struct Team {
    let title: String
    var members: [String]
    
    mutating func randomize() {
        members.shuffle()
    }
}

struct Crew {
    var teams: [Team] = [
        Team(title: "✏️ UX", members: ["Eric","Jules"]),
        Team(title: "🖼 UI", members: ["Christophe"]),
        Team(title: "⌨️ DEV", members: ["Jad", "Gwenn", "Oussam", "Aymen", "Slim", "Lana", "Guillaume", "Alvaro", "Marie-Odile"]),
        Team(title: "💊 TEST", members: ["Emilien", "Helena", "Ines"]),
        Team(title: "🕹 SCRUM", members: ["Maxime", "Jessica", "Johan"])
    ]
    
    mutating func randomizeMembers() {
        teams = teams.map { team in
            var team = team
            team.randomize()
            return team
        }
    }
    
    mutating func randomizeTeams() {
        teams = teams.shuffled()
    }
    
    mutating func randomizeAll() {
        teams = teams.map { team in
            var team = team
            team.randomize()
            return team
        }.shuffled()
    }
}


// from https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
