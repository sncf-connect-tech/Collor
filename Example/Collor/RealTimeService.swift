//
//  RealTimeService.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

class RealTimeService {
    
    enum RealTimeError : Error {
        case unknowError
        case networkError
    }
    
    enum RealTimeResponse {
        case success(RealTimeModel)
        case error(RealTimeError)
    }
    
    private static var maxIndex = 5
    private static var count = 0
    
    func getRecentTweets(completion: @escaping (RealTimeResponse)->Void ) {
        
        let url = "file://" + Bundle.main.path(forResource: "tweets_\(RealTimeService.count)", ofType: "json")!
        
        Alamofire.request(url).responseJSON { response in
            
            switch (response.result) {
            case .success(let data):
                if let dictionary = data as? [String:Any], let model = RealTimeModel(json: dictionary) {
                    completion( .success(model) )
                } else {
                    completion( .error( .unknowError ) )
                }
                break
            case .failure( _):
                break
                //completion( .error( .networkError ) )
            }
        }
        
        RealTimeService.count += 1
        if RealTimeService.count > RealTimeService.maxIndex {
            RealTimeService.count = 0
        }
    }
}
