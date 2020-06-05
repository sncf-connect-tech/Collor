//
//  RealTimeStyle.swift
//  Collor
//
//  Created by Guihal Gwenn on 07/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct RealTimeStyle {
    
    struct TweetInfo {
        
        static func keyAttributedString(text:String) -> NSAttributedString {
            let textAttString = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
                ])
            return textAttString
        }
        
        static func valueAttributedString(text:String) -> NSAttributedString {
            let textAttString = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.black
                ])
            return textAttString
        }
    }
}
