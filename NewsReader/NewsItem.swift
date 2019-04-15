//
//  NewsItem.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit

class NewsItem {
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
    var imageURL: String?
    var imageCaption: String?
    var image: UIImage?
    var category: String?
    var provider: Provider?
    
    var pubDate: Date?
    var formattedPubDateStr: String?
        
    var visited: Bool {
        get {
            if self.guid == nil {
                return false
            }
            if let visited = self.userDefaults.value(forKey: self.guid!) as? Bool {
                return visited
            }
            return false
        }
        set(value) {
            if value && self.guid != nil {
                self.userDefaults.setValue(value, forKey: self.guid!)
                self.userDefaults.synchronize()
            }
        }
    }
 
}
