//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var progressEggsView: UIProgressView!
    
    let eggTimes: [String: Double] = ["Soft": 300, "Medium": 420, "Hard": 720]
    var timer = Timer()
    
    let zeroDigit: Float = 0.0
    let oneDigit: Float = 1.0
    
    var player: AVAudioPlayer!
    
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        progressEggsView.progress = zeroDigit
        var totalTime = zeroDigit
        var secondsPassed = zeroDigit
        
        let hardness = sender.currentTitle!
        
        player?.stop()
        timer.invalidate()
        
        totalTime = Float(eggTimes[hardness]!)
        
        
        self.textLable.text = hardness
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(oneDigit), repeats: true) { _ in
            
            if secondsPassed < totalTime {
                secondsPassed += self.oneDigit
                
                self.progressEggsView.progress = Float(secondsPassed) / Float(totalTime)
                
            }else {
                self.textLable.text = "Complete"
                self.playSound(soundName: "alarm_sound")
            }
        }
        
        
        
    }
    func playSound(soundName: String?) {
        
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
    
}
