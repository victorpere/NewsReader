//
//  CustomProvider.swift
//  NewsReader
//
//  Created by Victor on 2019-08-11.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import CoreData

class CustomProvider : CacheItem {
    var name: String!
    var logo: AnyObject?
    var enabled = true
    
    override init() {
        super.init()
        self.entityName = "CacheCustomProvider"
        self.key = "name"
    }
    
    convenience init(name: String, logo: AnyObject?, enabled: Bool, objectID: NSManagedObjectID) {
        self.init()
        self.name = name
        self.logo = logo
        self.enabled = enabled
        self.objectID = objectID
    }
    
    static func all() -> [CustomProvider]? {
        let customProvider = CustomProvider()
        if let cacheCustomProviders = self.fetchAllFromCache(customProvider)() as? [CacheCustomProvider] {
            
            let customProviders = cacheCustomProviders.map { CustomProvider(name: $0.name!,logo: $0.logo as AnyObject?,enabled: $0.enabled, objectID: $0.objectID) }
            
            return customProviders
        }
        return nil
    }
    
    func save() -> Bool {
        self.values = ["name": self.name, "enabled": self.enabled]
        return self.saveWithObjectID()
    }
}
