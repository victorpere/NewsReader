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
    
    var visited: Bool = false
    var pubDate: Date?
}
