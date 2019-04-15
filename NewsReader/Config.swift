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
    
    public static let providerImages = [
        Provider.ctv: "providerImageCTV", Provider.cbc: "providerImageCBC"
    ]
    
    public static let newsFeeds = [
        Provider.ctv: [
            "Top Stories": "https://www.ctvnews.ca/rss/ctvnews-ca-top-stories-public-rss-1.822009",
            "Canada": "https://www.ctvnews.ca/rss/ctvnews-ca-canada-public-rss-1.822284",
            "World": "https://www.ctvnews.ca/rss/ctvnews-ca-world-public-rss-1.822289",
            "Entertainment": "https://www.ctvnews.ca/rss/ctvnews-ca-entertainment-public-rss-1.822292",
            "Politics": "https://www.ctvnews.ca/rss/ctvnews-ca-politics-public-rss-1.822302",
            "Lifestyle": "https://www.ctvnews.ca/rss/lifestyle/ctv-news-lifestyle-1.3407722",
            "Business": "https://www.ctvnews.ca/rss/business/ctv-news-business-headlines-1.867648",
            "Science & Tech": "https://www.ctvnews.ca/rss/ctvnews-ca-sci-tech-public-rss-1.822295",
            "Sports": "https://www.ctvnews.ca/rss/sports/ctv-news-sports-1.3407726",
            "Health": "https://www.ctvnews.ca/rss/ctvnews-ca-health-public-rss-1.822299",
            "Autos": "https://www.ctvnews.ca/rss/autos/ctv-news-autos-1.867636",
            "Toronto": "https://toronto.ctvnews.ca/rss/ctv-news-toronto-1.822319"
        ]
        ,
        Provider.cbc: [
            "Top Stories": "https://www.cbc.ca/cmlink/rss-topstories",
            "Canada": "https://rss.cbc.ca/lineup/canada.xml",
            "World": "https://rss.cbc.ca/lineup/world.xml",
            "Politics": "https://rss.cbc.ca/lineup/politics.xml",
            "Business": "https://rss.cbc.ca/lineup/business.xml",
            "Health": "https://rss.cbc.ca/lineup/health.xml",
            "Entertainment": "https://rss.cbc.ca/lineup/arts.xml",
            "Science & Tech": "https://rss.cbc.ca/lineup/technology.xml",
            "Offbeat": "https://rss.cbc.ca/lineup/offbeat.xml",
            "Indigenous": "https://www.cbc.ca/cmlink/rss-cbcaboriginal",
            "Sports": "https://rss.cbc.ca/lineup/sports.xml",
            "Toronto": "https://rss.cbc.ca/lineup/canada-toronto.xml",
            "In-depth": "https://rss.cbc.ca/lineup/thenational.xml"
        ]
        
    ]
    
    public static let topics = [
        "Top Stories",
        "Canada",
        "World",
        "Entertainment",
        "Politics",
        "Lifestyle",
        "Business",
        "Science & Tech",
        "Sports",
        "Health",
        "Autos",
        "Offbeat",
        "Indigenous",
        "Toronto",
        "In-depth"
    ]
    
    public static let classArticleHeadline : [Provider: String] = [
        Provider.ctv: "articleHeadline",
        Provider.cbc: "detailHeadline"
    ]
    
    public static let classArticleBody : [Provider: String] = [
        Provider.ctv: "articleBody",
        Provider.cbc: "story"
    ]
}
