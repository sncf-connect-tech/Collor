//
//  TweetAdapter.swift
//  Collor
//
//  Created by Guihal Gwenn on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor
import UIKit

struct TweetAdapter: CollectionAdapter, Diffable, Equatable {

    let label:NSAttributedString
    let imageURL:URL
    let backgroundColor:UIColor
    
    init(tweet:Tweet) {
        label = NSAttributedString(string: tweet.text, attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        imageURL = URL(string: tweet.userProfileImageURL)!
        backgroundColor = UIColor(rgb: tweet.color)
    }
}
