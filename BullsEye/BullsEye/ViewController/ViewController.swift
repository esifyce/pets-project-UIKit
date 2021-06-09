//
//  ViewController.swift
//  BullsEye
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var bullData = BullData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // slider custom design
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable =
          trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)

        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable =
          trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
        startNewRound()
        bullData.currentValue = 50
        slider.value = Float(bullData.currentValue)
        
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        bullData.currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        
        let difference = abs(bullData.targetValue-bullData.currentValue)
        var point = 100 - difference
        
        if difference == 0 {
            bullData.result = "Отлично!"
            point += 100
        } else if difference > 0 && difference < 10 {
            bullData.result = "У вас почти получилось!"
        } else {
            bullData.result = "Даже близко ..."
        }
        
        bullData.score += point
        
        let message = "Вы набрали \(point) очков"
        
        let alert = UIAlertController(title: bullData.result, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler:{ [weak self] _ in
            self?.startNewRound()
        })
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func startOverButtons(_ sender: UIButton) {
        
        bullData.score = 0
        bullData.round = 0
        
        startNewRound()
        
    }
    
    func startNewRound() {
        
        bullData.round += 1
        bullData.targetValue = Int.random(in: 1..<100)
        bullData.currentValue = Int(slider.value)
        slider.value = Float(bullData.currentValue)
        
        updateLabels()
        
        // анимация затухания поинтов
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
        
    }
    
    func updateLabels() {
        
        targetLabel.text = String(bullData.targetValue)
        scoreLabel.text = "\(bullData.score)"
        roundLabel.text = String(bullData.round)
        
    }
}

