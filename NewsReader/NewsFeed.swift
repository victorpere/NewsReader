//
//  NewsFeed.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class NewsFeed : NSObject {
    
    // MARK: - Variables
    
    let userDefaults = UserDefaults.standard
    let settings = Settings()

    var delegate: NewsFeedDelegate?
    var filter: String?
    var xmlBuffer: String!

    var dateFormatter = DateFormatter()
    var categories = [String]()
    var newsItems = [NewsItem]()
    var newsFeeds = [[NewsItem]]()
    
    var urlsLoaded = 0
    
    var lastUpdate: Date {
        get {
            if let lastUpdate = self.userDefaults.value(forKey: "lastUpdate") as? Date {
                return lastUpdate
            }
            return Date()
        }
        set(value) {
            self.userDefaults.setValue(value, forKey: "lastUpdate")
            self.userDefaults.synchronize()
        }
    }
    
//    var lastFeed: Int {
//        get {
//            if let lastFeed = self.userDefaults.value(forKey: "LastFeed") as? Int {
//                return lastFeed
//            }
//            return 0
//        }
//        set(value) {
//            self.userDefaults.setValue(value, forKey: "LastFeed")
//            self.userDefaults.synchronize()
//        }
//    }
    
    var title: String? {
        get {
            return Config.topics[self.settings.lastFeed]
        }
    }
    
    // MARK: - Public methods
    
    func refreshNewsFeed() {
        self.categories.removeAll()
        self.newsItems.removeAll()
        self.urlsLoaded = 0
        for (provider, _) in Config.newsFeeds {
            if self.settings.providerSetting(provider) {
                let q = DispatchQueue(label: "getNewsFeedQueue")
                q.async {
                    let newsFeedLoader = NewsFeedLoader()
                    newsFeedLoader.delegate = self
                    newsFeedLoader.loadFeed(provider: provider, topic: Config.topics[self.settings.lastFeed], filter: self.filter)
                    
                    /*
                     var xmlParser: XMLParser
                     
                     let path = Bundle.main.path(forResource: "ctvnews", ofType: "xml")
                     if path != nil {
                     xmlParser = XMLParser(contentsOf: URL(fileURLWithPath: path!))!
                     xmlParser.delegate = self
                     xmlParser.parse()
                     } else {
                     print("Failed to find MyFile.xml")
                     }
                     */
                }
            }
        }
    }
    
    // MARK: - Private methods
}

// MARK: - NewsFeedLoaderDelegate

extension NewsFeed : NewsFeedLoaderDelegate {
    func feedUpdated(newsItems: [NewsItem], categories: [String]) {
        self.newsItems.append(contentsOf: newsItems)
        self.newsItems.sort { $0.pubDate! > $1.pubDate! }
        self.urlsLoaded += 1
        
//        for category in categories {
//            if !self.categories.contains(category) {
//                self.categories.append(category)
//            }
//        }
//        self.categories.sort { $0 < $1 }

        self.lastUpdate = Date()
        self.delegate?.feedUpdated()
    }
}

// MARK: - protocol NewsFeedDelegate

protocol NewsFeedDelegate {
    func feedUpdated()
}
