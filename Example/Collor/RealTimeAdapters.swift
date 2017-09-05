//
//  RealTimeAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct RetweetAdapter : TweetInfoAdapterProtocol {
    let key: NSAttributedString
    let value: NSAttributedString
    init(tweet:Tweet) {
        key = NSAttributedString(string: "Retweets:")
        value = NSAttributedString(string: "\(tweet.retweetCount)")
    }
}

struct FavoriteAdapter : TweetInfoAdapterProtocol {
    let key: NSAttributedString
    let value: NSAttributedString
    init(tweet:Tweet) {
        key = NSAttributedString(string: "Favorites:")
        value = NSAttributedString(string: "\(tweet.favoriteCount)")
    }
}
