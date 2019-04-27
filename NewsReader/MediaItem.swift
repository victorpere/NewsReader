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
    var url: String?
    var media: AnyObject?
    var width: Double = 0
    var height: Double = 0
    var type: MediaType?
    var caption: String?
    
    func loadMedia() {
        if self.media == nil {
            if let mediaFromCache = Settings.mediaCache.object(forKey: self.url as AnyObject) {
                self.media = mediaFromCache
            } else if Settings.setting(for: "SettingImage") {
                do {
                    let mediaData = try Data(contentsOf: URL(string: self.url!)!)
                    let image = UIImage(data: mediaData)
                    
                    if (image != nil) {
                        self.media = image
                        self.width = Double(image?.size.width ?? 0)
                        
                        Settings.mediaCache.setObject(self.media!, forKey: self.url! as AnyObject)
                    }
                } catch {
                    
                }
            }
        }
    }
}
