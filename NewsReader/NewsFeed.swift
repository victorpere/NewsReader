//
//  NewsFeed.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit

class NewsFeed : NSObject {
    let userDefaults = UserDefaults.standard

    var delegate: NewsFeedDelegate?
    var filter: Category?
    var newsItems = [NewsItem]()
    var xmlBuffer: String!
    var dateFormatter = DateFormatter()
    
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
    
    var lastFeed: Int {
        get {
            if let lastFeed = self.userDefaults.value(forKey: "LastFeed") as? Int {
                return lastFeed
            }
            return 0
        }
        set(value) {
            self.userDefaults.setValue(value, forKey: "LastFeed")
            self.userDefaults.synchronize()
        }
    }
    
    var title: String? {
        get {
            return Config.feeds[lastFeed]["Description"]
        }
    }
    
    private var feedURL: String? {
        get {
            return Config.feeds[lastFeed]["Url"]
        }
    }
    
    // MARK: - Public methods
    
    func refreshNewsFeed() {
        let q = DispatchQueue(label: "getNewsFeedQueue")
        q.async {
            self.newsItems.removeAll()
            let requester = Requester()
            requester.delegate = self
            requester.getData(from: self.feedURL!)
            
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

// MARK: - RequesterDelegate

extension NewsFeed : RequesterDelegate {
    func receivedData(data: Data) {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

// MARK: - XMLParserDelegate

extension NewsFeed : XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.lastUpdate = Date()
        if self.filter != nil {
            self.newsItems = self.newsItems.filter { $0.category == self.filter }
        }
        self.delegate?.feedUpdated()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlBuffer = ""
        
        if elementName == "item" {
            // start new item
            self.newsItems.append(NewsItem())
        }
        
        if elementName == "enclosure" && newsItems.count > 0 {
            newsItems[newsItems.count - 1].imageURL = attributeDict["url"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.xmlBuffer.append(string)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let stringData = String(data: CDATABlock, encoding: .utf8)
        self.xmlBuffer = stringData as String!
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if newsItems.count > 0 {
            // parsing news item
            let newsItem = self.newsItems[newsItems.count - 1]
            
            switch elementName {
            case "item":
                newsItems.sort { $0.pubDate! > $1.pubDate! }
            case "title":
                newsItem.title = self.xmlBuffer
            case "link":
                newsItem.link  = self.xmlBuffer
                newsItem.categoryStr = newsItem.link!.category() != nil ? newsItem.link!.category() : "general"
                newsItem.category = Category(rawValue: newsItem.categoryStr!)
            case "description":
                newsItem.description = self.xmlBuffer
            case "author":
                newsItem.author = self.xmlBuffer
            case "dc:creator":
                newsItem.creator = self.xmlBuffer
            case "creditLine":
                newsItem.creditLine = self.xmlBuffer
            case "guid":
                newsItem.guid  = self.xmlBuffer
            case "pubDate":
                newsItem.pubDateStr = self.xmlBuffer
                newsItem.pubDate = newsItem.pubDateStr!.date() // dateFormatter.ctvdate(from: newsItem.pubDateStr!)
                newsItem.formattedPubDateStr = newsItem.pubDate?.formattedString()
            case "ctv:lastModifiedDate>":
                newsItem.modDateStr = self.xmlBuffer
            case "enclosure":
                newsItem.imageCaption = self.xmlBuffer
            default:
                break
            }
        } else {
            // parsing feed header
            switch elementName {
            case "title":
                //self.title = self.xmlBuffer
                break
            default:
                break
            }
        }
    }
}

// MARK: - protocol NewsFeedDelegate

protocol NewsFeedDelegate {
    func feedUpdated()
}
