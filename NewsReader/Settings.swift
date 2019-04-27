//
//  Settings.swift
//  NewsReader
//
//  Created by Victor on 2019-04-17.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation

public class Settings {
    static let userDefaults = UserDefaults.standard
    static let mediaCache = NSCache<AnyObject,AnyObject>() // todo: user CoreData for caching
    
    static var lastFeed: Int {
        get {
            if let lastFeed = Settings.userDefaults.value(forKey: "LastFeed") as? Int {
                return lastFeed
            }
            return 0
        }
        set(value) {
            Settings.userDefaults.setValue(value, forKey: "LastFeed")
            Settings.userDefaults.synchronize()
        }
    }
    
    public static func providerSetting(_ provider: Provider) -> Bool {
        if let setting = Settings.userDefaults.value(forKey: String(provider.name())) as? Bool {
            return setting
        }
        return true
    }
    
    public static func providerSetting(_ provider: Provider, _ setting: Bool) {
        Settings.userDefaults.setValue(setting, forKey: provider.name())
        Settings.userDefaults.synchronize()
    }
    
    public static func setting(for settingName: String) -> Bool {
        if let setting = Settings.userDefaults.value(forKey: settingName) as? Bool {
            return setting
        }
        return true
    }
    
    public static func setting(for settingName: String, to settingValue: Bool) {
        Settings.userDefaults.setValue(settingValue, forKey: settingName)
        Settings.userDefaults.synchronize()
    }
}
