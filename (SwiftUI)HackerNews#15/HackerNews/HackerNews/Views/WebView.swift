//
//  WebView.swift
//  HackerNews
//
//  Created by Sabir Myrzaev on 23.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//


import SwiftUI
import WebKit

// осуществление перехода в интернет на разные страницы по ссылкам
struct WebView: UIViewRepresentable {

    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
    }
    
}
