//
//  NewsReaderTests.swift
//  NewsReaderTests
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import XCTest
import CoreData
@testable import NewsReader

class NewsReaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFeed() {
        let newsFeed = NewsFeed()
        newsFeed.refreshNewsFeed()
        
        for newsItem in newsFeed.newsItems {
            XCTAssertNotNil(newsItem.title, "Title is nil")
            XCTAssertNotNil(newsItem.description, "Description is nil")
            XCTAssertNotNil(newsItem.pubDateStr, "PubDate is nil")
        }
    }
    
    func testCache() {
        let cache = Cache.init(completionClosure: {})
        
        //cache.deleteAll(entity: "CacheMediaItem")
        
        let url = "https://imgproc.airliners.net/photos/airliners/9/8/1/5515189-v42203641774-6.jpg"
        do {
            let mediaData = try Data(contentsOf: URL(string: url)!)
            
            XCTAssertNoThrow(cache.save(entity: "CacheMediaItem", keyName: "url", keyValue: url, values: ["media": mediaData]))
            
            let fetched = cache.fetch(entity: "CacheMediaItem", keyName: "url", keyValue: url)
            //XCTAssertNotNil(fetched)
            
            if (fetched != nil) {
                let cachedMediaItem = fetched as! CacheMediaItem
                XCTAssertNotNil(cachedMediaItem.media)
                
                print(cachedMediaItem.url ?? "url is nil")
            }
        } catch {
            
        }
    }
    
//    func testMedia() {
//        let cache = Cache.init(completionClosure: {})
//        cache.deleteAll(entity: "CacheMediaItem")
//        
//        let url = "https://imgproc.airliners.net/photos/airliners/9/8/1/5515189-v42203641774-6.jpg"
//        
//        let mediaItem = MediaItem()
//        mediaItem.url = url
//        mediaItem.loadMedia()
//        
//        let mediaItem2 = MediaItem()
//        mediaItem2.url = url
//        mediaItem2.loadMedia()
//        
//        let fetched = cache.fetch(entity: "CacheMediaItem", keyName: "url", keyValue: url)
//        XCTAssertNotNil(fetched)
//    }
}
