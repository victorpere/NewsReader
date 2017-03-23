//
//  Date.swift
//  NewsReader
//
//  Created by Victor on 2017-03-23.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

extension Date {
    public func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy h:mma"
        return dateFormatter.string(from: self)
    }
}
