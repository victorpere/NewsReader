//
//  NewsItem.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit

class NewsItem: CacheItem {
    let userDefaults = UserDefaults.standard
    var title: String?
    var link: String?
    var description: String?
    var author: String?
    var creator: String?
    var creditLine: String?
    var guid: String?
    var pubDateStr: String?
    var modDateStr: String?
    var imageCaption: String?
    var image: UIImage?
    var urlCategory: String?
    var provider: Provider?
    var categories = [String]()
    var mediaItems = [MediaItem]()
    
    var pubDate: Date?
    var formattedPubDateStr: String?
        
    var visited: Bool {
        get {
            self.keyValue = self.guid
            if let cachedNewsItem = self.fetchFromCache() as! CacheNewsItem? {
                if cachedNewsItem.visited {
                    return true
                }
            }
            return false
        }
        set(value) {
            if self.guid != nil {
                self.keyValue = self.guid
                self.values = ["visited" : value]
                let q = DispatchQueue(label: "NewsItemCaching")
                q.async {
                    self.saveToCache()
                }
            }
        }
    }
    
    override init() {
        super.init()
        self.entityName = "CacheNewsItem"
        self.key = "guid"
    }
}
