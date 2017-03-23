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
    var pageData: Data?
    
    //var webView: WKWebView!
    var webView: UIWebView!
    
    override func loadView() {
        //let webConfiguration = WKWebViewConfiguration()
        //self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //self.webView.uiDelegate = self
        self.webView = UIWebView(frame: .zero)
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
        //self.webView.load(myRequest)
        self.webView.loadRequest(myRequest)
    /*
        if self.pageData != nil {
            self.webView.load(self.pageData!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: URL(string: "http://www.ctvnews.ca")!)
        } else {
            self.webView.load(myRequest)
        }
 */
    }
}
