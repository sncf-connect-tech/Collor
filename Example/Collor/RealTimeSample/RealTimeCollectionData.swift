//
//  RealTimeCollectionData.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Collor

final class RealTimeCollectionData : CollectionData {
    
    var model:RealTimeModel?
    
    func update(model:RealTimeModel) {
        self.model = model
    }
    
    override func reloadData() {
        super.reloadData()
        
        guard let model = self.model else {
            return
        }
        
        model.tweets.forEach { tweet in
            let section = TweetSectionDescriptor().uid(tweet.id).reloadSection { cells in
                let tweetCell = TweetDescriptor(adapter: TweetAdapter(tweet: tweet)).uid("text")
                cells.append(tweetCell)
                if tweet.retweetCount > 0 {
                    let retweetCell = TweetInfoDescriptor(adapter: RetweetAdapter(tweet: tweet)).uid("retweet")
                    cells.append(retweetCell)
                }
                if tweet.favoriteCount > 0 {
                    let favoriteCell = TweetInfoDescriptor(adapter: FavoriteAdapter(tweet: tweet)).uid("favorite")
                    cells.append(favoriteCell)
                }
            }
            sections.append(section)
        }
    }
}

