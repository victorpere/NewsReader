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
    var objectID: NSManagedObjectID?
    
    func saveToCache() -> Bool {
        return self.cache.save(entity: self.entityName, keyName: self.key, keyValue: self.keyValue, values: self.values)
    }
    
    func saveWithObjectID() -> Bool {
        return self.cache.save(entity: self.entityName, objectID: self.objectID, values: self.values)
    }
    
    func fetchFromCache() -> NSManagedObject? {
        return self.cache.fetch(entity: self.entityName, keyName: self.key, keyValue: self.keyValue)
    }
    
    func fetchAllFromCache() -> [NSManagedObject]? {
        return self.cache.fetchAll(entity: self.entityName)
    }
    
    func fetchFromCacheWithID() -> NSManagedObject? {
        if (objectID != nil) {
            return self.cache.fetch(with: objectID!)
        }
        return nil
    }
}
