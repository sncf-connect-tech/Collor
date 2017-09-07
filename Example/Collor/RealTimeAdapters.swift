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
        key = RealTimeStyle.TweetInfo.keyAttributedString(text: "Retweets:")
        value = RealTimeStyle.TweetInfo.valueAttributedString(text: "\(tweet.retweetCount)")
    }
}

struct FavoriteAdapter : TweetInfoAdapterProtocol {
    let key: NSAttributedString
    let value: NSAttributedString
    init(tweet:Tweet) {
        key = RealTimeStyle.TweetInfo.keyAttributedString(text: "Favorites:")
        value = RealTimeStyle.TweetInfo.valueAttributedString(text: "\(tweet.favoriteCount)")
    }
}
