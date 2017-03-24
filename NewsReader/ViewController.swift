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
    @IBOutlet weak var filterButton: UIButton!
    
    fileprivate var newsFeed = NewsFeed()
    var reachability: Reachability?
    
// MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Stories"
        
        self.reachability = Reachability()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Last refreshed: \(self.newsFeed.lastUpdate.formattedString())")
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
        self.tableView.delegate = self
        self.newsFeed.delegate = self
        
        self.tableView.estimatedRowHeight = 160;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.refreshFeed()
    }
    
// MARK: - Actions
    
    @IBAction func filterButtonAction(_ sender: Any) {
        let filterAlert = UIAlertController(title: "Filter by category:", message: nil, preferredStyle: .actionSheet)
        
        let allCategoriesAction = UIAlertAction(title: "All", style: .default, handler: { (alert) -> Void in
            self.newsFeed.filter = nil
            self.refreshFeed()
        } )
        filterAlert.addAction(allCategoriesAction)
        
        for category in Category.categories {
            let categoryAction = UIAlertAction(title: category.rawValue, style: .default, handler: { (alert) -> Void in
                self.newsFeed.filter = category
                self.refreshFeed()
            } )
            filterAlert.addAction(categoryAction)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in }
        filterAlert.addAction(cancelButton)
        
        let alertController = filterAlert.popoverPresentationController
        alertController?.permittedArrowDirections = .up
        alertController?.sourceView = self.filterButton
        alertController?.sourceRect = self.filterButton.bounds
        
        self.present(filterAlert, animated: true, completion: nil)
    }
    
// MARK: - Private methods
    
    @objc private func refreshFeed() {
        // check for internet connectivity
        if !(self.reachability?.isReachable)! {
            self.tableView.refreshControl!.endRefreshing()
            let alert = UIAlertController(title: "No iternet connection available", message: "Cannot refresh feed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let q = DispatchQueue.global(qos: .userInitiated)
            q.async {
                self.newsFeed.getNewsFeed()
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.newsFeed.newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewsItem") as? NewsItemCell
        
        if (cell == nil) {
            cell = UINib(nibName: "NewsItemCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NewsItemCell
        }
        
        if indexPath.row < self.newsFeed.newsItems.count {
            // update labels from the news item
            
            let newsItem = self.newsFeed.newsItems[indexPath.row]
            
            cell!.tag = indexPath.row
            cell!.titleLabel.text = newsItem.title
            cell!.descriptionLabel.text = newsItem.description
            cell!.dateLabel.text = newsItem.formattedPubDateStr
            
            if newsItem.categoryStr != nil {
                cell!.categoryLabel.text = newsItem.categoryStr
                cell!.categoryLabel.isHidden = false
            } else {
                cell!.categoryLabel.isHidden = true
            }
            
            let q1 = DispatchQueue(label: "visitedLabelQueue")
            q1.async {
                if newsItem.visited {
                    DispatchQueue.main.async {
                        cell!.visitedImage.isHidden = false
                    }
                } else {
                    DispatchQueue.main.async {
                        cell!.visitedImage.isHidden = true
                    }
                }
            }

            if newsItem.image != nil {
                cell?.newsImageView.image = newsItem.image
            } else if newsItem.imageURL != nil {
                // asynchronously download the image
                let q2 = DispatchQueue.global(qos: .userInitiated)
                q2.async {
                    do {
                        let imageData = try Data(contentsOf: URL(string: newsItem.imageURL!)!)
                        let image = UIImage(data: imageData)
                        if image != nil {
                            newsItem.image = image
                            DispatchQueue.main.async {
                                if cell!.tag == indexPath.row {
                                    cell!.newsImageView.image = image
                                    cell!.setNeedsLayout()
                                }
                            }
                        }
                    } catch let error as NSError {
                        print("error loading image data: \(error)")
                    }
                }
            }
        }
        return cell!
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // check for internet connectivity
        if !(self.reachability?.isReachable)! {
            let alert = UIAlertController(title: "No iternet connection available", message: "Cannot open item", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let newsItem = self.newsFeed.newsItems[indexPath.row]
            
            let q1 = DispatchQueue(label: "setVisitedQueue")
            q1.async {
                newsItem.visited = true
            }
            
            let cell = self.tableView.cellForRow(at: indexPath) as? NewsItemCell
            cell?.visitedImage.isHidden = false
            
            let detailScreen = WebViewController(nibName: nil, bundle: nil)
            detailScreen.url = newsItem.link
            self.navigationController?.pushViewController(detailScreen, animated: true)
        }
    }
}

// MARK: - NewsFeedDelegate

extension ViewController: NewsFeedDelegate {
    func feedUpdated() {
        // the news feed has been updated - reload table view
        DispatchQueue.main.async {
            let refreshControl = self.tableView.refreshControl!
            refreshControl.attributedTitle = NSAttributedString(string: "Last refreshed: \(self.newsFeed.lastUpdate.formattedString())")
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
