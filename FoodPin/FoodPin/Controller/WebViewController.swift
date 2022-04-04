//
//  WebViewController.swift
//  FoodPin
//
//  Created by Sabir Myrzaev on 3/4/22.
//

import UIKit
import WebKit
import SafariServices

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    var targetURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

