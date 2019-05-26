//
//  CacheItem.swift
//  NewsReader
//
//  Created by Victor on 2019-05-13.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import CoreData

class CacheItem {
    var entityName: String!
    var key: String!
    var keyValue: Any!
    var values: Dictionary<String,Any?> = [:]
    var cache = Cache.init(completionClosure: {})
    
    func saveToCache() {
        self.cache.save(entity: self.entityName, keyName: self.key, keyValue: self.keyValue, values: self.values)
    }
    
    func fetchFromCache() -> NSManagedObject? {
        return self.cache.fetch(entity: self.entityName, keyName: self.key, keyValue: self.keyValue)
    }
}
