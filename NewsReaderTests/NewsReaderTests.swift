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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFeed() {
        let newsFeed = NewsFeed()
        newsFeed.getNewsFeed()
        
    }
    
    func testCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StoredNewsItem")
        
        do {
            let items: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            let item = items.filter { $0.value(forKeyPath: "guid") as? String == "123" }.first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
