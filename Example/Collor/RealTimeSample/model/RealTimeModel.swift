//
//  RealTimeModel.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class RealTimeModel {
    
    let tweets:[Tweet]
    
    init?( json:[String:Any] ) {
        
        guard let tweetsList = json["tweets"] as? [[String:Any]] else {
            return nil
        }
        
        tweets = tweetsList.compactMap { tweetData -> Tweet? in
            guard let id = tweetData["id_str"] as? String,
                let text = tweetData["text"] as? String,
                let user = tweetData["user"] as? [String:Any],
                let userProfileImageURL = user["profile_image_url"] as? String,
                let colorStr = user["color"] as? String, let color = Int(colorStr, radix: 16),
                let favoriteCount = tweetData["favorite_count"] as? Int,
                let retweetCount = tweetData["retweet_count"] as? Int else {
                    return nil
            }
            return Tweet(id: id, text: text, userProfileImageURL: userProfileImageURL, color: color, favoriteCount: favoriteCount, retweetCount: retweetCount)
        }
    }
}

struct Tweet {
    let id:String
    let text:String
    let userProfileImageURL:String
    let color:Int
    let favoriteCount:Int
    let retweetCount:Int
}
