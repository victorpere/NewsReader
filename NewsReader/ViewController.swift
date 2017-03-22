//
//  ViewController.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newsFeed = NewsFeed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        newsFeed.delegate = self
        newsFeed.getNewsFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return newsFeed.newsItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.textLabel?.text = newsFeed.newsItems[indexPath.row].title
        
        let titleLabel = UILabel(frame: CGRect(x: 50, y: 0, width: cell.frame.width, height: 40))
        titleLabel.text = newsFeed.newsItems[indexPath.row].title
        cell.contentView.addSubview(titleLabel)
        
        let pubDateLabel = UILabel(frame: CGRect(x: 50, y: 40, width: cell.frame.width, height: 20))
        pubDateLabel.text = newsFeed.newsItems[indexPath.row].pubDateStr
        cell.contentView.addSubview(pubDateLabel)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsFeed.newsItems[indexPath.row].visited = true
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailScreen = WebViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension ViewController: NewsFeedDelegate {
    func feedUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
