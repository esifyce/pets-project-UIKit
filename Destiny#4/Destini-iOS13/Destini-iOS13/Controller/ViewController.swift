//
//  ViewController.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    
    var storyBrain = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyUI()

    }

    @IBAction func choiceMade(_ sender: UIButton) {
        
        storyBrain.nextStory(UserChoice: sender.currentTitle!)
        storyUI()
        
    }
    
    func storyUI(){
        
        //let example = Story(text: "You see a fork in the road.", ch1: "Take a left", ch2: "Take a right")
        let answerChoices = storyBrain.getAnswers()
        let oneChoices = storyBrain.getChoicesOne()
        let twoChoices = storyBrain.getChoicesTwo()
        
        storyLabel.text = answerChoices
        
        choice1Button.setTitle(oneChoices, for: .normal)
        
        choice2Button.setTitle(twoChoices, for: .normal)
    }
    
    
    
}

