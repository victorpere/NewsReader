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
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sources"
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Provider.allCases.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        switch indexPath.section {
        case 0:
            let provider = Provider.allCasesSortedByName()[indexPath.row]
            cell.imageView?.image = UIImage(named: Config.providerImages[provider]!)
            cell.textLabel?.text = provider.name()
            cell.detailTextLabel?.text = Settings.providerSetting(provider) ? "On" : "Off"
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel?.text = "Download images"
            cell.selectionStyle = .none
            let switchImage = UISwitch()
            switchImage.isOn = Settings.setting(for: self.switchImageSetting)
            switchImage.tag = self.switchImageTag
            switchImage.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchImage
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
        case 0:
            self.tableView.deselectRow(at: indexPath, animated: true)
            let provider = Provider.allCasesSortedByName()[indexPath.row]
            Settings.providerSetting(provider, !Settings.providerSetting(provider))
            self.settingsChanged = true
            self.tableView.reloadData()
        default:
            break
        }
    }
}

// MARK: - Protocol SettingsViewControllerDelegate

protocol SettingsViewControllerDelegate {
    func settingsUpdated()
}
