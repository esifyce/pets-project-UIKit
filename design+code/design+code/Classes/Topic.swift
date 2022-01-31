//
//  Topic.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit

class Topic {
    var topicName: String
    var topicSymbol: String
    
    init(name: String!, icon: String!) {
        self.topicName = name
        self.topicSymbol = icon
    }
}

let topics = [
    Topic(name: "iOS Development", icon: "apps.iphone"),
    Topic(name: "UI Design", icon: "eyedropper"),
    Topic(name: "Web Development", icon: "desktopcomputer")
]
