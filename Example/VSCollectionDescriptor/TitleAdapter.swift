//
//  TitleAdapter.swift
//  VSCollectionDescriptor
//
//  Created by Guihal Gwenn on 22/02/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import VSCollectionDescriptor
import Foundation

struct TitleAdapter: VSCollectionAdapter {

    let title:String
    
    init(title:String) {
        self.title = title
    }

}
