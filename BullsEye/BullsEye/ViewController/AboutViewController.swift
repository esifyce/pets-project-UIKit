//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Sabir Myrzaev on 09.06.2021.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if let url = Bundle.main.url(
          forResource: "Bullseye", withExtension: "html") {
          let request = URLRequest(url: url)
          webView.load(request)
            view.setNeedsLayout()
        }

    }
}
