//
//  ViewController.swift
//  NewsReader
//
//  Created by Victor on 2017-03-21.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    let toolBarHeight: CGFloat = 30.0
    let rowHeight: CGFloat = 160.0
    
    // MARK: - Variables

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var newsFeed = NewsFeed()
    var reachability: Reachability?
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Top Stories"
        
        self.reachability = Reachability()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Last refreshed: \(self.newsFeed.lastUpdate.formattedString())")
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        
//        let searchController = UISearchController(searchResultsController: self)
//
//        if #available(iOS 11.0, *) {
//            self.navigationItem.searchController = searchController
//            self.navigationItem.hidesSearchBarWhenScrolling = true
//        } else {
//            self.tableView.tableHeaderView = searchController.searchBar
//        }
        
        self.tableView.refreshControl = refreshControl
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.newsFeed.delegate = self
        
        self.tableView.estimatedRowHeight = self.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshFeed()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.height - self.toolBarHeight, width: self.view.frame.width, height: self.toolBarHeight))
        let feedButton = UIBarButtonItem(title: "Topic", style: .plain, target: self, action: #selector(selectFeed(_:)))
        let filterButton = UIBarButtonItem(title: "Category", style: .plain, target: self, action: #selector(filterButtonAction(_:)))
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonAction(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        toolBar.setItems([feedButton, flexibleSpace, settingsButton], animated: true)
        self.view.addSubview(toolBar)
        
        let refreshButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshFeed))
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    // MARK: - Button actions

    @objc private func filterButtonAction(_ sender: UIBarButtonItem) {
        let filterAlert = UIAlertController(title: "Select category:", message: nil, preferredStyle: .actionSheet)
        
        let allCategoriesAction = UIAlertAction(title: "All", style: .default, handler: { (alert) -> Void in
            self.newsFeed.filter = nil
            self.refreshFeed()
        } )
        filterAlert.addAction(allCategoriesAction)
        
        for category in self.newsFeed.categories {
            let categoryAction = UIAlertAction(title: category, style: .default, handler: { (alert) -> Void in
                self.newsFeed.filter = category
                self.refreshFeed()
            } )
            filterAlert.addAction(categoryAction)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in }
        filterAlert.addAction(cancelButton)
        
        let alertController = filterAlert.popoverPresentationController
        alertController?.permittedArrowDirections = .up
        alertController?.barButtonItem = sender
        
        self.present(filterAlert, animated: true, completion: nil)
    }
    
    @objc fileprivate func refreshFeed() {
        DispatchQueue.main.async {
            self.title = Config.topics[Settings.lastFeed]
        }
        // check for internet connectivity
        if !(self.reachability?.isReachable)! {
            self.tableView.refreshControl!.endRefreshing()
            let alert = UIAlertController(title: "No iternet connection available", message: "Cannot refresh", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let q = DispatchQueue.global(qos: .userInitiated)
            q.async {
                self.newsFeed.refreshNewsFeed()
            }
        }
    }
    
    @objc private func selectFeed(_ sender: UIBarButtonItem) {
        let feedAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (i, feed) in Config.topics.enumerated() {
            var feedTitle = feed
            if Settings.lastFeed == i {
                feedTitle.insert(" ", at: feedTitle.startIndex)
                feedTitle.insert("✓", at: feedTitle.startIndex)
            }
            let feedAction = UIAlertAction(title: feedTitle, style: .default, handler: { (alert) -> Void in
                if Settings.lastFeed != i {
                    Settings.lastFeed = i
                    self.newsFeed.filter = nil
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 0 - UIApplication.shared.statusBarFrame.size.height - (self.navigationController?.navigationBar.frame.size.height)!), animated: false)
                    self.refreshFeed()
                }
            } )
            feedAlert.addAction(feedAction)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in }
        feedAlert.addAction(cancelButton)
        
        let alertController = feedAlert.popoverPresentationController
        alertController?.permittedArrowDirections = .down
        alertController?.barButtonItem = sender
        
        self.present(feedAlert, animated: true, completion: nil)
    }
    
    @objc private func settingsButtonAction(_ sender: UIBarButtonItem) {
        let settingsViewController = SettingsViewController(nibName: nil, bundle: nil)
        settingsViewController.delegate = self
        let navSettingsViewController = UINavigationController(rootViewController: settingsViewController)
        navSettingsViewController.modalPresentationStyle = .popover
        //settingsViewController.delegate = self
        
        let presentationController = navSettingsViewController.popoverPresentationController
        presentationController?.permittedArrowDirections = .down
        //presentationController?.sourceView = sender.button
        //presentationController?.sourceRect = sender.bounds
        
        self.present(navSettingsViewController, animated: true, completion: nil)
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
            cell!.guid = newsItem.guid
            cell!.titleLabel.text = newsItem.title
            cell!.descriptionLabel.text = newsItem.description
            cell!.dateLabel.text = newsItem.formattedPubDateStr
            cell!.providerImage.image = UIImage(named: Config.providerImages[newsItem.provider!]!)
            
            if newsItem.categories.count > 0 {
                cell!.categoryLabel.text = newsItem.categories[0]
                cell!.categoryLabel.isHidden = false
            } else if newsItem.urlCategory != nil {
                cell!.categoryLabel.text = newsItem.urlCategory
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
            } else if newsItem.mediaItems.count > 0 {
                // asynchronously download the image
                let q2 = DispatchQueue.global(qos: .userInitiated)
                q2.async {
                    let largestImage = newsItem.mediaItems.max { a,b in a.width < b.width }
                    largestImage?.loadMedia()
                    
                    let image = largestImage?.media as? UIImage
                    if image != nil && largestImage!.width > 100.0 {
                        newsItem.image = image
                        DispatchQueue.main.async {
                            if cell!.tag == indexPath.row && cell!.guid == newsItem.guid {
                                cell!.newsImageView.image = image
                                cell!.setNeedsLayout()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell?.newsImageView.image = nil
                        }                        
                    }
                }
            } else {
                cell?.newsImageView.image = nil
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
            
            //let detailScreen = WebViewController(nibName: nil, bundle: nil)
            //detailScreen.url = newsItem.link
            
            let detailScreen = StoryViewController(url: newsItem.link!)
            detailScreen.newsItem = newsItem
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
            //self.title = self.newsFeed.title
            self.tableView.reloadData()
            self.tableView.contentSize = CGSize(width: self.tableView.frame.width, height: self.tableView.contentSize.height + self.toolBarHeight)
        }
    }
}

// MARK: - SettingsViewControllerDelegate

extension ViewController: SettingsViewControllerDelegate {
    func settingsUpdated() {
        self.refreshFeed()
    }
}
