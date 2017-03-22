//
//  WebViewController.swift
//  NewsReader
//
//  Created by Victor on 2017-03-22.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var url: String!
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
    
        self.webView.load(myRequest)
    }
}
