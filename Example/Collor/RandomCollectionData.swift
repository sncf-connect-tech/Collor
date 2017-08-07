//
//  RandomCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class RandomCollectionData : CollectionDatas {
    
    var crew:Crew?
    
    func reload(crew:Crew) {
        self.crew = crew
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let crew = crew else {
            return
        }
        
        crew.teams.forEach { team in
            
            let section = RandomSectionDescriptor().uid(team.title).reloadSection { cells in
                let titleItem = TitleDescriptor(adapter: TeamTitleAdapter(teamTitle: team.title)).uid(team.title)
                cells.append(titleItem)
                
                team.members.forEach { member in
                    let memberItem = LabelDescriptor(adapter: TeamMemberAdapter(member: member)).uid(member)
                    cells.append(memberItem)
                }
            }
            sections.append( section )
        }
    }
}

