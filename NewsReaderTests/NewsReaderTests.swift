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
        newsFeed.getNewsFeed()
        
        for newsItem in newsFeed.newsItems {
            XCTAssertNotNil(newsItem.title, "Title is nil")
            XCTAssertNotNil(newsItem.description, "Description is nil")
            XCTAssertNotNil(newsItem.pubDateStr, "PubDate is nil")
        }
    }
    
}
