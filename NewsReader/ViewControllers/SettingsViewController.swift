//
//  SettingsViewController.swift
//  NewsReader
//
//  Created by Victor on 2019-04-19.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Variables
    
    let settings = Settings()
    
    var tableView: UITableView!
    var delegate: SettingsViewControllerDelegate!
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Button actions
    
    @objc private func doneButtonAction(_ sender: UIBarButtonItem) {
        self.delegate.settingsUpdated()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Provider.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let provider = Provider.allCasesSortedByName()[indexPath.row]
        cell.imageView?.image = UIImage(named: Config.providerImages[provider]!)
        cell.textLabel?.text = provider.name()
        cell.detailTextLabel?.text = self.settings.ProviderSetting(provider) ? "On" : "Off"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let provider = Provider.allCasesSortedByName()[indexPath.row]
        self.settings.ProviderSetting(provider, !self.settings.ProviderSetting(provider))
        self.tableView.reloadData()
    }
}

// MARK: - Protocol SettingsViewControllerDelegate

protocol SettingsViewControllerDelegate {
    func settingsUpdated()
}
