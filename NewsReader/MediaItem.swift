//
//  MediaItem.swift
//  NewsReader
//
//  Created by Victor on 2019-04-19.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation

class MediaItem : NSObject {
    var url: String?
    var media: NSObject?
    var width: Double = 0
    var height: Double = 0
    var type: MediaType?
    var caption: String?
}
