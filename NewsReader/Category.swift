//
//  Category.swift
//  NewsReader
//
//  Created by Victor on 2017-03-23.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import Foundation

public enum Category: String {
    case general = "general"
    case canada = "canada"
    case world = "world"
    case health = "health"
    case politics = "politics"
    case sports = "sports"
    case scitech = "sci-tech"
    case business = "business"
    
    public static let categories = [business, canada, health, politics, scitech, sports, world]
}
