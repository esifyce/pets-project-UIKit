//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Sabir Myrzaev on 08.05.2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct Question {
    let text: String
    let answer: [String]
    let rightAnswer: String
    init(q: String, a: [String], correctAnswer: String) {
        text = q
        answer = a
        rightAnswer = correctAnswer
    }
}
