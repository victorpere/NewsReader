//
//  String.swift
//  NewsReader
//
//  Created by Victor on 2017-03-22.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

extension DateFormatter {
    public func ctvdate(from string: String) -> Date? {
        self.dateFormat = "dd MMM yyyy HH:mm:ss"
        let start = string.index(string.startIndex, offsetBy: 5)
        let end = string.index(string.endIndex, offsetBy: -6)
        let range = start..<end
        let datestring = string.substring(with: range)
        return self.date(from: datestring)
    }
}
