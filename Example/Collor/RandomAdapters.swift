//
//  RandomAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.. All rights reserved.
//

import Foundation
import Collor
import UIKit

struct TeamTitleAdapter : TitleAdapterProtocol {
    let title: NSAttributedString
    var lineColor: UIColor = .lightGray
    var cellHeight: CGFloat = 40
    
    init(team: Team) {
        self.title = NSAttributedString(string: team.title, attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
    }
}

struct TeamMemberAdapter: LabelAdapterProtocol {
    let label:NSAttributedString
    var height: CGFloat? = 30
    var width: CGFloat? = 111 // handly computed :)
    
    init(member: String) {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        self.label = NSAttributedString(string: member, attributes: [
            NSAttributedStringKey.paragraphStyle:  style,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
    }
}
