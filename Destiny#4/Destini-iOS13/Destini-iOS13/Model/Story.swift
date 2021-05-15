//
//  Sotry.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct Story {
    
    let text: String
    let ch1: String
    let ch2: String
    let ch1Dest: Int
    let ch2Dest: Int
    
    init(title: String, choice1: String, choice1Destination: Int, choice2: String, choice2Destination: Int) {
        text = title
        ch1 = choice1
        ch2 = choice2
        ch1Dest = choice1Destination
        ch2Dest = choice2Destination
        
    }
    
}
