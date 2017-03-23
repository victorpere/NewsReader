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
}
