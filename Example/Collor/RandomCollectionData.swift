//
//  RandomCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor

final class RandomCollectionData : CollectionData {
    
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
            
            let section = RandomSectionDescriptor().uid(team.title).reloadSection { (cells, supplementaryViews) in
                let titleItem = TitleDescriptor(adapter: TeamTitleAdapter(team: team)).uid(team.title)
                cells.append(titleItem)
                
                team.members.forEach { member in
                    let memberItem = LabelDescriptor(adapter: TeamMemberAdapter(member: member)).uid(member)
                    cells.append(memberItem)
                }
                
                supplementaryViews["hello"] = [BackgroundColorSuppViewDescriptor(adapter: BackgroundColorSuppViewAdapter(color: UIColor.blue))]
            }
            sections.append( section )
        }
    }
}

