//
//  MediaItem.swift
//  NewsReader
//
//  Created by Victor on 2019-04-19.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit

class MediaItem: CacheItem {
    
    // MARK: - Variables
    
    var url: String?
    var media: AnyObject?
    var width: Double = 0
    var height: Double = 0
    var type: MediaType?
    var caption: String?
    
    override init() {
        super.init()
        self.entityName = "CacheMediaItem"
        self.key = "url"
    }
    
    // MARK: - Public methods
    
    func loadMedia() {
        if self.media == nil {
            self.keyValue = self.url
            if let cachedMediaItem = self.fetchFromCache() as! CacheMediaItem? {
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
                            self.values = ["media" : mediaData]
                            self.saveToCache()
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
