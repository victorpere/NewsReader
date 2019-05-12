//
//  MediaItem.swift
//  NewsReader
//
//  Created by Victor on 2019-04-19.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit

class MediaItem {
    
    // MARK: - Variables
    
    var url: String?
    var media: AnyObject?
    var width: Double = 0
    var height: Double = 0
    var type: MediaType?
    var caption: String?
    
    var cache = Cache.init(completionClosure: {})
    
    // MARK: - Public methods
    
    func loadMedia() {
        if self.media == nil {
            if let cachedMediaItem = cache.fetch(entity: "CacheMediaItem", keyName: "url", keyValue: self.url!) as! CacheMediaItem? {
                if cachedMediaItem.media != nil, let image = UIImage(data: cachedMediaItem.media! as Data) {
                    self.media = image
                    self.width = Double(image.size.width)
                    return
                }
            }
            
            if self.url != nil && Settings.setting(for: "SettingImage") {
                do {
                    let mediaData = try Data(contentsOf: URL(string: self.url!)!)
                    if let image = UIImage(data: mediaData) {
                        self.media = image
                        self.width = Double(image.size.width)
                        
                        let q = DispatchQueue(label: "MediaCaching")
                        q.async {
                            self.cache.save(entity: "CacheMediaItem", keyName: "url", keyValue: self.url!, values: ["media" : mediaData])
                        }
                        
                        return
                    }
                } catch {
                    
                }
            }
            
            self.width = 0
        }
    }
}
