//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var trueTwoButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    

    
    var quizBrain = QuizBrain()
    var oneDigit = 1.0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle! // True, False
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
       
        if userGotItRight{
            sender.backgroundColor = UIColor.green
            
        }else{
            sender.backgroundColor = UIColor.red
        }
            
        
        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
    }

    
    @objc func updateUI(){
            
            let answerChoices = quizBrain.getAnswers()
            trueTwoButton.setTitle(answerChoices[0], for: .normal)
            trueButton.setTitle(answerChoices[1], for: .normal)
            falseButton.setTitle(answerChoices[2], for: .normal)
                
            questionLabel.text = quizBrain.getQuestionText()
            progressBar.progress = quizBrain.getProgress()
        
            scoreLabel.text = "Score: \(quizBrain.getScore())"
        
            self.trueButton.backgroundColor = UIColor.clear
            self.trueTwoButton.backgroundColor = UIColor.clear
            self.falseButton.backgroundColor = UIColor.clear
        
    }
}

