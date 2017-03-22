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
    
    func getNewsFeed() {
        newsItems.removeAll()
        let requester = Requester()
        requester.delegate = self
        requester.getData(from: feedURL)
    }
}

extension NewsFeed : RequesterDelegate {
    func receivedData(data: Data) {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

extension NewsFeed : XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.delegate?.feedUpdated()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //print()
        //print("start element ", elementName)
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
        //print(string, terminator: "")
        xmlBuffer.append(string)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        //print("foundCDATA")
        let stringData = String(data: CDATABlock, encoding: .utf8)
        //print(stringData)
        
        xmlBuffer = stringData as String!
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print()
        //print("end element ", elementName)
        
        if newsItems.count > 0 {
            // parsing news item
            switch elementName {
            case "item":
                newsItems.sort { $0.pubDate! > $1.pubDate! }
                
            case "title":
                newsItems[newsItems.count - 1].title = xmlBuffer
            case "link":
                newsItems[newsItems.count - 1].link  = xmlBuffer
            case "description":
                newsItems[newsItems.count - 1].description = xmlBuffer
            case "author":
                newsItems[newsItems.count - 1].author = xmlBuffer
            case "dc:creator":
                newsItems[newsItems.count - 1].creator = xmlBuffer
            case "creditLine":
                newsItems[newsItems.count - 1].creditLine = xmlBuffer
            case "guid":
                newsItems[newsItems.count - 1].guid  = xmlBuffer
            case "pubDate":
                newsItems[newsItems.count - 1].pubDateStr = xmlBuffer
                newsItems[newsItems.count - 1].pubDate = dateFormatter.ctvdate(from: newsItems[newsItems.count - 1].pubDateStr!)
            case "ctv:lastModifiedDate>":
                newsItems[newsItems.count - 1].modDateStr = xmlBuffer
            case "enclosure":
                newsItems[newsItems.count - 1].imageCaption = xmlBuffer
            default:
                break
            }
        } else {
            // parsing feed header
            switch elementName {
            case "title":
                self.title = xmlBuffer
            default:
                break
            }
        }
    }
}

protocol NewsFeedDelegate {
    func feedUpdated()
}
