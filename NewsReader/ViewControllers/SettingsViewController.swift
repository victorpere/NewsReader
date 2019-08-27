//
//  SettingsViewController.swift
//  NewsReader
//
//  Created by Victor on 2019-04-19.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Constants
    
    let switchImageTag = 0
    let switchImageSetting = "SettingImage"
    
    // MARK: - Variables
    
    var tableView: UITableView!
    var delegate: SettingsViewControllerDelegate!
    var settingsChanged = false
    var cache = Cache(completionClosure: {})
    var customProviders: [CustomProvider]?
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customProviders = CustomProvider.all()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Button actions
    
    @objc private func doneButtonAction(_ sender: UIBarButtonItem) {
        if (self.settingsChanged) {
            self.delegate.settingsUpdated()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func switchChanged(_ theswitch: UISwitch) {
        switch theswitch.tag {
        case self.switchImageTag:
            Settings.setting(for: self.switchImageSetting, to: theswitch.isOn)
        default:
            break
        }
        self.settingsChanged = true
    }
    
    // MARK: - Private methods
    
    private func clearReadItems() {
        let q = DispatchQueue(label: "cache")
        q.async {
            self.cache.deleteAll(entity: "CacheNewsItem")
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SettingsSections.Providers.rawValue:
            return "Sources"
        case SettingsSections.Images.rawValue:
            return ""
        case SettingsSections.Cache.rawValue:
            return "Cache"
        case SettingsSections.CustomProviders.rawValue:
            return "Custom Sources"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsSections.Providers.rawValue:
            return Provider.allCases.count
        case SettingsSections.Images.rawValue:
            return 1
        case SettingsSections.Cache.rawValue:
            return 2
        case SettingsSections.CustomProviders.rawValue:
            return (self.customProviders?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        switch indexPath.section {
        case SettingsSections.Providers.rawValue:
            let provider = Provider.allCasesSortedByName()[indexPath.row]
            cell.imageView?.image = UIImage(named: Config.providerImages[provider]!)
            cell.textLabel?.text = provider.name()
            cell.detailTextLabel?.text = Settings.providerSetting(provider) ? "On" : "Off"
            cell.accessoryType = .disclosureIndicator
        case SettingsSections.Images.rawValue:
            cell.textLabel?.text = "Download images"
            cell.selectionStyle = .none
            let switchImage = UISwitch()
            switchImage.isOn = Settings.setting(for: self.switchImageSetting)
            switchImage.tag = self.switchImageTag
            switchImage.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchImage
        case SettingsSections.Cache.rawValue:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Clear image cache"
                cell.textLabel?.textColor = self.view.tintColor
            case 1:
                cell.textLabel?.text = "Clear read list"
                cell.textLabel?.textColor = self.view.tintColor
            default:
                break
            }
        case SettingsSections.CustomProviders.rawValue:
            // Custom providers
        // TODO: replace the main providers section with this?
            if indexPath.row >= self.customProviders?.count ?? 0 {
                cell.textLabel?.text = "Add new source..."
            } else {
                let provider = (self.customProviders?[indexPath.row])!
                cell.textLabel?.text = provider.name
                cell.detailTextLabel?.text = provider.enabled ? "On" : "Off"
            }
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SettingsSections.Providers.rawValue:
            // TODO: this section should be replaced with custom providers
            self.tableView.deselectRow(at: indexPath, animated: true)
            let provider = Provider.allCasesSortedByName()[indexPath.row]
            
            Settings.providerSetting(provider, !Settings.providerSetting(provider))
            self.settingsChanged = true
            self.tableView.reloadData()
            
        case SettingsSections.Images.rawValue:
            break
        case SettingsSections.Cache.rawValue:
            switch indexPath.row {
            case 0:
                self.tableView.deselectRow(at: indexPath, animated: true)
                Settings.mediaCache.removeAllObjects()
                self.cache.deleteAll(entity: "CacheMediaItem")
                self.settingsChanged = true
            case 1:
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.clearReadItems()
                self.settingsChanged = true
            default:
                break
            }
        case SettingsSections.CustomProviders.rawValue:
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            // Custom providers
            var provider = CustomProvider()
            if (indexPath.row < self.customProviders?.count ?? 0) {
                provider = (self.customProviders?[indexPath.row])!
            }
            let providerSettingsViewController = ProviderSettingsViewController(for: provider, nibName: nil, bundle: nil)
            providerSettingsViewController.delegate = self
            self.navigationController?.pushViewController(providerSettingsViewController, animated: true)

            break
        default:
            break
        }
    }
}

// MARK: - Extension ProviderSettingsViewControllerDelegate

extension SettingsViewController : ProviderSettingsViewControllerDelegate {
    func providerSettingsChanged() {
        self.settingsChanged = true
    }
}

// MARK: - Protocol SettingsViewControllerDelegate

protocol SettingsViewControllerDelegate {
    func settingsUpdated()
}

// MARK: - Enums

enum SettingsSections: Int, CaseIterable {
    case
        Providers = 0,
        Images = 1,
        Cache = 2,
        CustomProviders = 3
}
