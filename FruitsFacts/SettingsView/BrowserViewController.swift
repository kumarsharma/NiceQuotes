//
//  BrowserViewController.swift
//  FruitsFacts
//
//  Created by Kumar Sharma on 19/10/21.
//

import UIKit
import WebKit
import SafariServices

class BrowserViewController: UIViewController, WKNavigationDelegate {

    let webView = WKWebView()
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var progressBar: UIProgressView!
    
    override func loadView() {
        
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.title = "Privacy Policy"
        if let url = URL(string: "https://www.myniceapps.com/privacy/") {
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }    
}
