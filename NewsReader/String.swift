//
//  String.swift
//  NewsReader
//
//  Created by Victor on 2017-03-23.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

extension String {
    public func category() -> String? {
        let endIndex = self.range(of: "/", options: .backwards)?.lowerBound
        let categoryLink = self.substring(with: self.startIndex..<endIndex!)
        let startIndex = categoryLink.range(of: "/", options: .backwards)?.upperBound
        let range = startIndex..<endIndex!
        let category = self.substring(with: range)
        
        return category.capitalizeFirst()
    }
    
    public func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        let start = self.index(self.startIndex, offsetBy: 5)
        let end = self.index(self.endIndex, offsetBy: -6)
        let range = start..<end
        let datestring = self.substring(with: range)
        return dateFormatter.date(from: datestring)
    }
    
    public func capitalizeFirst() -> String? {
        let firstLetter = self.prefix(1).uppercased()
        return firstLetter + self.suffix(self.count - 1)
    }
}
