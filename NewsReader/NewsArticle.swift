//
//  NewsStory.swift
//  NewsReader
//
//  Created by Victor on 2019-03-11.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import SwiftSoup

class NewsArticle {
    var document: Document!
    var headline: String!
    var body: String!
    var provider: Provider!
    
    // MARK: - Initializers
    
    init(html: String, provider: Provider) {
        guard let document: Document = try? SwiftSoup.parse(html) else { return }
        self.headline = self.textFrom(document: document, cssClass: Config.classArticleHeadline[provider]!)
        self.body = self.textFrom(document: document, cssClass: Config.classArticleBody[provider]!)
        self.provider = provider
        self.document = document
    }
    
    // MARK: - Private methods
    
    func textFrom(document: Document, cssClass: String) -> String {
        var text = ""
        guard let elements = try? document.getElementsByClass(cssClass) else { return text }
        for element in elements {
            do {
                let paragraphs: Elements = try element.select("p")
                if paragraphs.size() > 0 {
                    for paragraph in paragraphs {
                        try? text.append("\(paragraph.text())\n\n")
                    }
                } else {
                    try? text.append("\(element.text())\n")
                }
            } catch {
                try? text.append("\(element.text())\n")
            }
        }
        return text
    }
}
