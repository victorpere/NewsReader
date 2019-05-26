//
//  String.swift
//  NewsReader
//
//  Created by Victor on 2017-03-23.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

extension String {
    public func categoryUrl() -> String? {
        let endIndex = self.range(of: "/", options: .backwards)?.lowerBound
        let categoryLink = String(self[self.startIndex..<endIndex!])
        let startIndex = categoryLink.range(of: "/", options: .backwards)?.upperBound
        let range = startIndex!..<endIndex!
        let category = String(self[range])
        
        return category.capitalizeFirst()
    }

    public func category() -> String? {
        if !self.contains("/") {
            return self
        }
        
        let startIndex = self.range(of: "/", options: .backwards)?.lowerBound
        return String(self[self.index(startIndex!, offsetBy: 1)..<self.endIndex])
    }
    
    public func categories() -> [String] {
        var categories: [String] = []
        for substr in self.split(separator: ",") {
            categories.append(String(substr).category() ?? "")
        }
        return categories
    }
    
    public func date() -> Date? {
        let dateFormatter = DateFormatter()
        switch self.count {
        case 28:
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
        case 29:
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        case 30:
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        case 31:
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        default:
            break
        }
        
//        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
//        let start = self.index(self.startIndex, offsetBy: 5)
//        let end = self.index(self.startIndex, offsetBy: 25)
//        let range = start..<end
//        let datestring = self.substring(with: range)
//        return dateFormatter.date(from: datestring)
        return dateFormatter.date(from: self)
    }
    
    public func capitalizeFirst() -> String? {
        let firstLetter = self.prefix(1).uppercased()
        return firstLetter + self.suffix(self.count - 1)
    }
}
