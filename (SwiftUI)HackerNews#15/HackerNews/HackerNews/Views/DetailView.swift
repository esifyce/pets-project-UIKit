//
//  DetailView.swift
//  HackerNews
//
//  Created by Sabir Myrzaev on 23.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
