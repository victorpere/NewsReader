//
//  Config.swift
//  NewsReader
//
//  Created by Victor on 2017-03-24.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

public class Config {
    public static let fontSizeArticleHeadline = 24.0
    public static let fontSizeArticleBody = 16.0
    
    public static let providers = [
        ["Name": "CTV", "Provider": "CTV"],
        ["Name": "CBC", "Provider": "CBC"]
    ]
    public static let feeds = [
        ["Description": "Top Stories", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-top-stories-public-rss-1.822009", "Provider": "CTV"],
        ["Description": "Canada", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-canada-public-rss-1.822284", "Provider": "CTV"],
        ["Description": "World", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-world-public-rss-1.822289", "Provider": "CTV"],
        ["Description": "Entertainment", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-entertainment-public-rss-1.822292", "Provider": "CTV"],
        ["Description": "Politics", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-politics-public-rss-1.822302", "Provider": "CTV"],
        ["Description": "Lifestyle", "Url": "https://www.ctvnews.ca/rss/lifestyle/ctv-news-lifestyle-1.3407722", "Provider": "CTV"],
        ["Description": "Business", "Url": "https://www.ctvnews.ca/rss/business/ctv-news-business-headlines-1.867648", "Provider": "CTV"],
        ["Description": "Science & Tech", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-sci-tech-public-rss-1.822295", "Provider": "CTV"],
        ["Description": "Sports", "Url": "https://www.ctvnews.ca/rss/sports/ctv-news-sports-1.3407726", "Provider": "CTV"],
        ["Description": "Health", "Url": "https://www.ctvnews.ca/rss/ctvnews-ca-health-public-rss-1.822299", "Provider": "CTV"],
        ["Description": "Autos", "Url": "https://www.ctvnews.ca/rss/autos/ctv-news-autos-1.867636", "Provider": "CTV"],
        
        //["Description" : "Top Stories", "Url": "https://rss.cbc.ca/lineup/topstories.xml", "Provider": "CBC"],
    ]
}
