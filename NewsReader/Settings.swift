//
//  Settings.swift
//  NewsReader
//
//  Created by Victor on 2019-04-17.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation

public class Settings {
    let userDefaults = UserDefaults.standard
    
    var lastFeed: Int {
        get {
            if let lastFeed = self.userDefaults.value(forKey: "LastFeed") as? Int {
                return lastFeed
            }
            return 0
        }
        set(value) {
            self.userDefaults.setValue(value, forKey: "LastFeed")
            self.userDefaults.synchronize()
        }
    }
    
    func providerSetting(_ provider: Provider) -> Bool {
        if let setting = self.userDefaults.value(forKey: String(provider.name())) as? Bool {
            return setting
        }
        return true
    }
    
    func providerSetting(_ provider: Provider, _ setting: Bool) {
        self.userDefaults.setValue(setting, forKey: provider.name())
        self.userDefaults.synchronize()
    }
}
