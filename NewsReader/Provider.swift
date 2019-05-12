//
//  Providers.swift
//  NewsReader
//
//  Created by Victor on 2019-03-11.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation

public enum Provider: Int, CaseIterable {
    case ctv, cbc, guardian, bbc, huff, global, seattletimes
    
    func name() -> String {
        switch self {
        case .ctv:
            return "CTV"
        case .cbc:
            return "CBC"
        case .guardian:
            return "The Guardian"
        case .bbc:
            return "BBC"
        case .huff:
            return "Huffington Post"
        case.global:
            return "Global"
        case.seattletimes:
            return "Seattle Times"
        default:
            return "Other"
        }
    }
    
    static func allCasesSortedByName() -> [Provider] {
        return Provider.allCases.sorted { $0.name() < $1.name() }
    }
}
