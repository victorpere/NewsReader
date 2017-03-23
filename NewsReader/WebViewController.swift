//
//  WebViewController.swift
//  NewsReader
//
//  Created by Victor on 2017-03-22.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var url: String!
    var activityIndicator: UIActivityIndicatorView!

// MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        self.view.addSubview(webView)
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
        webView.loadRequest(myRequest)
    }
}

// MARK: - UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
