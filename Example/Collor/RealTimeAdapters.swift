//
//  RealTimeAdapters.swift
//  Collor
//
//  Created by Guihal Gwenn on 05/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

struct RetweetAdapter : TweetInfoAdapterProtocol, Diffable {
    let key: NSAttributedString
    let value: NSAttributedString
    init(tweet:Tweet) {
        key = RealTimeStyle.TweetInfo.keyAttributedString(text: "Retweets:")
        value = RealTimeStyle.TweetInfo.valueAttributedString(text: "\(tweet.retweetCount)")
    }
    
    func isEqual(to other: Diffable?) -> Bool {
        guard let other = other as? RetweetAdapter else {
            return false
        }
        return key.string == other.key.string && value.string == other.value.string
    }
}

struct FavoriteAdapter : TweetInfoAdapterProtocol, Diffable {
    let key: NSAttributedString
    let value: NSAttributedString
    init(tweet:Tweet) {
        key = RealTimeStyle.TweetInfo.keyAttributedString(text: "Favorites:")
        value = RealTimeStyle.TweetInfo.valueAttributedString(text: "\(tweet.favoriteCount)")
    }
    
    func isEqual(to other: Diffable?) -> Bool {
        guard let other = other as? FavoriteAdapter else {
            return false
        }
        return key.string == other.key.string && value.string == other.value.string
    }
}
