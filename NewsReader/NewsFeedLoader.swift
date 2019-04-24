//
//  NewsFeedLoader.swift
//  NewsReader
//
//  Created by Victor on 2019-04-14.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class NewsFeedLoader : NSObject {
    var newsItems = [NewsItem]()
    var categories = [String]()
    var provider: Provider?
    var xmlBuffer: String!
    var filter: String?
    var loadImages = false

    var delegate: NewsFeedLoaderDelegate?
    
    // MARK: - Public methods
    func loadFeed(provider: Provider, topic: String, filter: String?) {
        if let feedUrl = Config.newsFeeds[provider]![topic] {
            self.provider = provider
            self.filter = filter
            let requester = Requester()
            requester.delegate = self
            requester.getData(from: feedUrl)
        }
    }
    
    // MARK: - Private methods
    func feedLoaded() {
        self.newsItems = self.newsItems.filter { self.filter == nil || $0.categories.contains(self.filter!) }
        for item in self.newsItems {
            item.provider = self.provider
            for mediaItem in item.mediaItems {
                if mediaItem.width == 0 {
                    let q = DispatchQueue(label: "ImageLoadFromNewsFeedLoader")
                    q.async {
                        do {
                            let imageData = try Data(contentsOf: URL(string: mediaItem.url!)!)
                            let image = UIImage(data: imageData)
                            if image != nil {
                                mediaItem.media = image
                                mediaItem.width = Double(image?.size.width ?? 0)
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        self.delegate?.feedUpdated(newsItems: self.newsItems, categories: self.categories)
    }
}

// MARK: - RequesterDelegate

extension NewsFeedLoader : RequesterDelegate {
    func receivedData(data: Data) {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

// MARK: - XMLParserDelegate

extension NewsFeedLoader : XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        self.categories.removeAll()
        self.newsItems.removeAll()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.feedLoaded()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.xmlBuffer = ""
        
        switch elementName {
        case "item":
            // start new item
            self.newsItems.append(NewsItem())
        case "enclosure","media:content","media:thumbnail":
            if loadImages && self.newsItems.count > 0 {
                let mediaItem = MediaItem()
                mediaItem.url = attributeDict["url"]
                mediaItem.width = Double(attributeDict["width"] ?? "0")!
                self.newsItems[self.newsItems.count - 1].mediaItems.append(mediaItem)
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.xmlBuffer.append(string)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        self.xmlBuffer = String(data: CDATABlock, encoding: .utf8)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if self.newsItems.count > 0 {
            // parsing news item
            let newsItem = self.newsItems[self.newsItems.count - 1]
            
            switch elementName {
            case "item":
                newsItems.sort { $0.pubDate! > $1.pubDate! }
            case "title":
                newsItem.title = self.xmlBuffer
            case "link":
                newsItem.link  = self.xmlBuffer
                newsItem.urlCategory = newsItem.link!.categoryUrl() != nil ? newsItem.link!.categoryUrl() : "General"
                if (!self.categories.contains(newsItem.urlCategory!)) {
                    self.categories.append(newsItem.urlCategory!)
                }
            case "description":
                newsItem.description = self.xmlBuffer
                
                guard let document: Document = try? SwiftSoup.parse(self.xmlBuffer!) else { break }
                guard let imgs = try? document.getElementsByTag("img") else { break }
                for img in imgs {
                    guard let url = try? img.attr("src") else { break }
                    let mediaItem = MediaItem()
                    mediaItem.url = url
                    newsItem.mediaItems.append(mediaItem)
                }
                guard let text = try? document.text() else { break }
                newsItem.description = text
                
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
            case "category":
                //newsItem.category = self.xmlBuffer.category()
                let category = self.xmlBuffer.category()
                if category != nil {
                    newsItem.categories.append(category!)
                }
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

protocol NewsFeedLoaderDelegate {
    func feedUpdated(newsItems: [NewsItem], categories: [String])
}
