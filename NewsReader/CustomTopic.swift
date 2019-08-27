//
//  CustomTopic.swift
//  NewsReader
//
//  Created by Victor on 2019-08-11.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation

class CustomTopic : CacheItem {
    var name: String!
    var url: String!
    var providerName: String!
    var enabled = true
    
    override init() {
        super.init()
        self.entityName = "CacheCustomTopic"
        self.key = "name"
    }
}
