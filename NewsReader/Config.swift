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
        Provider.ctv: "providerImageCTV",
        Provider.cbc: "providerImageCBC",
        Provider.guardian: "providerImageGuardian",
        Provider.bbc: "providerImageBBC",
        //Provider.huff: "providerImageHuff",
        Provider.global: "providerImageGlobal",
        Provider.seattletimes: "providerImageSeattleTimes"
    ]
    
    public static let newsFeeds = [
        Provider.ctv: [
            "Top Stories": "https://www.ctvnews.ca/rss/ctvnews-ca-top-stories-public-rss-1.822009",
            "Canada": "https://www.ctvnews.ca/rss/ctvnews-ca-canada-public-rss-1.822284",
            "World": "https://www.ctvnews.ca/rss/ctvnews-ca-world-public-rss-1.822289",
            "Arts & Entertainment": "https://www.ctvnews.ca/rss/ctvnews-ca-entertainment-public-rss-1.822292",
            "Politics": "https://www.ctvnews.ca/rss/ctvnews-ca-politics-public-rss-1.822302",
            "Lifestyle": "https://www.ctvnews.ca/rss/lifestyle/ctv-news-lifestyle-1.3407722",
            "Business": "https://www.ctvnews.ca/rss/business/ctv-news-business-headlines-1.867648",
            "Science": "https://www.ctvnews.ca/rss/ctvnews-ca-sci-tech-public-rss-1.822295",
            "Technology": "https://www.ctvnews.ca/rss/ctvnews-ca-sci-tech-public-rss-1.822295",
            "Sports": "https://www.ctvnews.ca/rss/sports/ctv-news-sports-1.3407726",
            "Health": "https://www.ctvnews.ca/rss/ctvnews-ca-health-public-rss-1.822299",
            "Autos": "https://www.ctvnews.ca/rss/autos/ctv-news-autos-1.867636",
            "Toronto": "https://toronto.ctvnews.ca/rss/ctv-news-toronto-1.822319"
        ],
        Provider.cbc: [
            "Top Stories": "https://www.cbc.ca/cmlink/rss-topstories",
            "Canada": "https://rss.cbc.ca/lineup/canada.xml",
            "World": "https://rss.cbc.ca/lineup/world.xml",
            "Politics": "https://rss.cbc.ca/lineup/politics.xml",
            "Business": "https://rss.cbc.ca/lineup/business.xml",
            "Health": "https://rss.cbc.ca/lineup/health.xml",
            "Arts & Entertainment": "https://rss.cbc.ca/lineup/arts.xml",
            "Technology": "https://rss.cbc.ca/lineup/technology.xml",
            "Offbeat": "https://rss.cbc.ca/lineup/offbeat.xml",
            "Indigenous": "https://www.cbc.ca/cmlink/rss-cbcaboriginal",
            "Sports": "https://rss.cbc.ca/lineup/sports.xml",
            "Toronto": "https://rss.cbc.ca/lineup/canada-toronto.xml"
        ],
        Provider.guardian: [
            "Top Stories": "https://www.theguardian.com/theguardian/mainsection/topstories/rss",
            "World": "https://www.theguardian.com/world/rss",
            "Opinion": "https://www.theguardian.com/uk/commentisfree/rss",
            "Sports": "https://www.theguardian.com/uk/sport/rss",
            "Arts & Entertainment": "https://www.theguardian.com/uk/culture/rss",
            //"Lifestyle": "https://www.theguardian.com/uk/lifeandstyle/rss",
            "Science": "https://www.theguardian.com/science/rss",
            "Technology": "https://www.theguardian.com/uk/technology/rss",
            "Business": "https://www.theguardian.com/uk/business/rss",
            "Health": "https://www.theguardian.com/lifeandstyle/health-and-wellbeing/rss"
        ],
        Provider.bbc: [
//            "Top Stories": "http://feeds.bbci.co.uk/news/rss.xml",
//            "World": "http://feeds.bbci.co.uk/news/world/rss.xml",
//            "Business": "http://feeds.bbci.co.uk/news/business/rss.xml",
//            "Politics": "http://feeds.bbci.co.uk/news/politics/rss.xml",
//            "Health": "http://feeds.bbci.co.uk/news/health/rss.xml",
            "Science": "http://feeds.bbci.co.uk/news/science_and_environment/rss.xml",
//            "Technology": "http://feeds.bbci.co.uk/news/technology/rss.xml",
//            "Arts & Entertainment": "http://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml"
        ],
//        Provider.huff: [
//            "World": "https://www.huffpost.com/section/world-news/feed",
//            //"Canada": "https://www.huffpost.com/topic/canada/feed"
//        ]
        Provider.global: [
            "Top Stories": "https://globalnews.ca/feed/",
            "World": "https://globalnews.ca/world/feed/",
            "Canada": "https://globalnews.ca/canada/feed/",
            "Politics": "https://globalnews.ca/politics/feed/",
            "Business": "https://globalnews.ca/money/feed/",
            "Health": "https://globalnews.ca/health/feed/",
            "Arts & Entertainment": "https://globalnews.ca/entertainment/feed/",
            "Technology": "https://globalnews.ca/tech/feed/",
            "Sports": "https://globalnews.ca/tech/feed/",
            "Toronto": "https://globalnews.ca/toronto/feed/",
        ],
        Provider.seattletimes: [
            "Aerospace": "https://www.seattletimes.com/boeing-aerospace/feed/"
        ]
    ]
    
    public static let topics = [
        "Top Stories",
        "Canada",
        "World",
        "Arts & Entertainment",
        "Politics",
        "Opinion",
        "Lifestyle",
        "Business",
        "Science",
        "Technology",
        "Sports",
        "Health",
        "Autos",
        "Offbeat",
        "Indigenous",
        "Toronto",
        "Aerospace",
    ]
    
    public static let articleSections = [
        "Headline",
        "Body"
    ]
    
    public static let classArticleHeadline : [Provider: String] = [
        Provider.ctv: "articleHeadline",
        Provider.cbc: "detailHeadline",
        Provider.guardian: "content__headline",
        Provider.bbc: "story-body__h1",
        Provider.global: "gn-speakable-title",
        Provider.seattletimes: "article-title",
    ]
    
    public static let classArticleBody : [Provider: String] = [
        Provider.ctv: "articleBody",
        Provider.cbc: "story",
        Provider.guardian: "content__article-body",
        Provider.bbc: "story-body__inner",
        Provider.global: "story-txt",
        Provider.seattletimes: "article-content",
    ]
}
