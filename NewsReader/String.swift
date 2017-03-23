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
        let startIndex = self.index(self.startIndex, offsetBy: 22)
        let endIndex = self.range(of: "/", options: .backwards)?.lowerBound
        let range = startIndex..<endIndex!
        
        return self.substring(with: range)
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
}
