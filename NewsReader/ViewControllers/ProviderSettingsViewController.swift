//
//  ProviderSettingsViewController.swift
//  NewsReader
//
//  Created by Victor on 2019-08-04.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import UIKit

class ProviderSettingsViewController : UIViewController {
    
    // MARK: - Variables
    var tableView: UITableView!
    var provider: CustomProvider?
    var delegate: ProviderSettingsViewControllerDelegate!
    
    // MARK: - Initializers
    init(for provider: CustomProvider, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.provider = provider
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "Edit Source"
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
}

// MARK: - UITableViewDataSource

extension ProviderSettingsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Details"
        case 1:
            return "Topics"
        case 2:
            return "CSS classes"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // provider details
            return 1
        case 1:
            return Config.topics.count
        case 2:
            return Config.articleSections.count
        default:
            return 0
        }        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        switch indexPath.section {
        case 0:
            // editable: name and logo
            switch indexPath.row {
            case 0:
                let textEditCell = (UINib(nibName: "TextEditCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? TextEditCell)!
                textEditCell.name.text = "Source name"
                textEditCell.value.text = self.provider?.name ?? ""
                textEditCell.value.delegate = textEditCell
                textEditCell.delegate = self
                return textEditCell
            case 1:
                cell.textLabel?.text = "Logo"
            default:
                break
            }
            break
        case 1:
            cell.textLabel?.text = Config.topics[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case 2:
            let textEditCell = (UINib(nibName: "TextEditCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? TextEditCell)!
            textEditCell.name.text = Config.articleSections[indexPath.row]

            return textEditCell
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProviderSettingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MASRK: - TextEditCellDelegate

extension ProviderSettingsViewController : TextEditCellDelegate {
    func didFinishEditing(_ text: String) {
        // save text value (provider/source name)
        self.provider?.name = text
        self.provider?.enabled = true // TODO: use switch
        if (!(self.provider?.save())!) {
            // save failed
        }
    }
    
}

// MARK: - protocol ProviderSettingsViewControllerDelegate

protocol ProviderSettingsViewControllerDelegate {
    func providerSettingsChanged()
}
