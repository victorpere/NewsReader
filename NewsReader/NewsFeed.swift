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
    let feedURL = "http://www.ctvnews.ca/rss/ctvnews-ca-top-stories-public-rss-1.822009"
    
    var delegate: NewsFeedDelegate?
    
    var title: String?
    var link: String?
    var desc: String?
    var lastBuildDate: Date?
    var imageURL: String?
    var image: UIImage?
    var language: String?
    var copyright: String?
    
    var newsItems = [NewsItem]()
    
    var xmlBuffer: String!
    var dateFormatter = DateFormatter()
    
// MARK: - Public methods
    
    func getNewsFeed() {
        let q = DispatchQueue(label: "getNewsFeedQueue")
        q.async {
            self.newsItems.removeAll()
            let requester = Requester()
            requester.delegate = self
            requester.getData(from: self.feedURL)
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
                let q = DispatchQueue(label: "categoryQueue")
                q.async {
                    newsItem.category = newsItem.link!.category()
                }
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
                newsItem.pubDate = dateFormatter.ctvdate(from: newsItem.pubDateStr!)
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
                self.title = self.xmlBuffer
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
