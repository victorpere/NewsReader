//
//  StoryViewController.swift
//  NewsReader
//
//  Created by Victor on 2019-03-10.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import SwiftSoup

class StoryViewController: UIViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    var articleImageView: UIImageView!
    
    var url: String!
    var activityIndicator: UIActivityIndicatorView!
    var newsArticle: NewsArticle?
    
    var articleHeadlineLabel: UILabel!
    var articleBodyLabel: UILabel!
    var articleImage: UIImage!
    
    let sidemargin: Int = 5
    
    // MARK: - Initializers
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scrollView)
        
        self.contentView = UIView(frame: self.view.frame)
        
        self.articleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.articleImage.size.height/self.articleImage.size.width)*self.view.frame.width))
        self.articleImageView.image = self.articleImage
        self.contentView.addSubview(self.articleImageView)
        
        self.articleHeadlineLabel = UILabel(frame: CGRect(x: 5, y: self.articleImageView.frame.origin.y + self.articleImageView.frame.height, width: self.view.frame.width, height: 0))
        self.articleHeadlineLabel.backgroundColor = .white
        self.articleHeadlineLabel.lineBreakMode = .byWordWrapping
        self.articleHeadlineLabel.numberOfLines = 0
        self.articleHeadlineLabel.font = UIFont.systemFont(ofSize: 24.0)
        self.contentView.addSubview(self.articleHeadlineLabel)
        
        self.articleBodyLabel = UILabel(frame: CGRect(x: 5, y: self.articleHeadlineLabel.frame.origin.y + self.articleHeadlineLabel.frame.height, width: self.view.frame.width, height: 0))
        self.articleBodyLabel.backgroundColor = .white
        self.articleBodyLabel.lineBreakMode = .byWordWrapping
        self.articleBodyLabel.numberOfLines = 0
        self.articleBodyLabel.font = UIFont.systemFont(ofSize: 16.0)
        self.contentView.addSubview(self.articleBodyLabel)
        
        self.scrollView.addSubview(contentView)
        
        let requester = Requester()
        requester.delegate = self
        requester.getData(from: self.url)
    }
}

// MARK: - Requester Delegate

extension StoryViewController: RequesterDelegate {
    func receivedData(data: Data) {
        let q1 = DispatchQueue.global(qos: .userInitiated)
        q1.async {
            let stringData = String(data: data, encoding: .utf8)!
            self.newsArticle = NewsArticle(html: stringData, provider: .ctv)
            DispatchQueue.main.async {
                self.articleHeadlineLabel.text = self.newsArticle?.headline
                self.articleBodyLabel.text = self.newsArticle?.body
                self.articleHeadlineLabel.sizeToFit()
                self.articleBodyLabel.frame.origin.y = self.articleHeadlineLabel.frame.origin.y + self.articleHeadlineLabel.frame.height
                self.articleBodyLabel.sizeToFit()
                
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.articleImageView.frame.height +
                    self.articleHeadlineLabel.frame.height +
                    self.articleBodyLabel.frame.height)
            }
        }
    }
}
