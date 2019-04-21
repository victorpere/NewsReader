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
    
    func ProviderSetting(_ provider: Provider) -> Bool {
        if let setting = self.userDefaults.value(forKey: String(provider.name())) as? Bool {
            return setting
        }
        return true
    }
    
    func ProviderSetting(_ provider: Provider, _ setting: Bool) {
        self.userDefaults.setValue(setting, forKey: provider.name())
        self.userDefaults.synchronize()
    }
}
