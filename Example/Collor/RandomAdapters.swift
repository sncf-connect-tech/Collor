//
//  RandomAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor
import UIKit

struct TeamTitleAdapter : TitleAdapterProtocol {
    let title: NSAttributedString
    var lineColor: UIColor = .lightGray
    var cellHeight: CGFloat = 40
    
    init(teamTitle: String) {
        self.title = NSAttributedString(string: teamTitle, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
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
            NSParagraphStyleAttributeName:  style,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor.black
            ])
    }
}
