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
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshFeed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        newsFeed.delegate = self
        refreshFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshFeed() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            self.newsFeed.getNewsFeed()
        }
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
        
        cell.tag = indexPath.row
        
        var titleLabel = cell.contentView.viewWithTag(1) as! UILabel?
        if titleLabel == nil {
            titleLabel = UILabel(frame: CGRect(x: 100, y: 0, width: cell.frame.width, height: 40))
            titleLabel?.tag = 1
            cell.contentView.addSubview(titleLabel!)
        }
        titleLabel?.text = newsFeed.newsItems[indexPath.row].title
        
        var pubDateLabel = cell.contentView.viewWithTag(2) as! UILabel?
        if pubDateLabel == nil {
            pubDateLabel = UILabel(frame: CGRect(x: 100, y: 40, width: cell.frame.width, height: 20))
            pubDateLabel?.tag = 2
            cell.contentView.addSubview(pubDateLabel!)
        }
        pubDateLabel?.text = newsFeed.newsItems[indexPath.row].pubDateStr
        
        var imageView = cell.contentView.viewWithTag(3) as! UIImageView?
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView?.tag = 3
            cell.contentView.addSubview(imageView!)
        }
    
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            do {
                let imageData = try Data(contentsOf: URL(string: self.newsFeed.newsItems[indexPath.row].imageURL!)!)
                let image = UIImage(data: imageData)
                if image != nil {
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row {
                            imageView?.image = image
                            cell.setNeedsLayout()
                        }
                    }
                }
            } catch let error as NSError {
                print("error loading image data: \(error)")
            }

        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsFeed.newsItems[indexPath.row].visited = true
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailScreen = WebViewController(nibName: nil, bundle: nil)
        detailScreen.url = newsFeed.newsItems[indexPath.row].link
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController: NewsFeedDelegate {
    func feedUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
