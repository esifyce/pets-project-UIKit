//
//  TimerManager.swift
//  AlarmApp
//
//  Created by Sabir Myrzaev on 01.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

class TimerManager: ObservableObject{
    
    var player: AVAudioPlayer!
    
    @Published var timerMode: TimerMode = .initial
    
    @Published var secondsLeftHour = UserDefaults.standard.integer(forKey: "timerLenghtHour")
    
    @Published var secondsLeftMin = UserDefaults.standard.integer(forKey: "timerLenghtMin")
    
    @Published var secondsLeftSec = UserDefaults.standard.integer(forKey: "timerLenghtSec")
    
    var timer = Timer()
    
    // Словари часов, минут, секунд
    
    func setTimerLengthHour(hours: Int){
        let defaultsHours = UserDefaults.standard
        defaultsHours.set(hours, forKey: "timeLenghtHour")
        secondsLeftHour = hours
    }
    func setTimerLengthMin(minutes: Int){
        let defaultsMin = UserDefaults.standard
        defaultsMin.set(minutes, forKey: "timeLenghtMin")
        secondsLeftMin = minutes
    }
    func setTimerLengthSec(seconds: Int){
        let defaultsSec = UserDefaults.standard
        defaultsSec.set(seconds, forKey: "timeLenghtSec")
        secondsLeftSec = seconds
    }
    
    func start(){
        self.player?.stop()
        timerMode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            switch self.secondsLeftSec {
            case 0:
                
                if self.secondsLeftMin == 0 && self.secondsLeftSec == 0 && self.secondsLeftHour == 0{
                    self.reset()
                    timer.invalidate()
                    self.playSound(soundName: "05446")
                    
                } else if self.secondsLeftMin != 0{
                    self.secondsLeftMin -= 1
                    self.secondsLeftSec = 59
                    
                } else if self.secondsLeftHour != 0{
                    self.secondsLeftHour -= 1
                    self.secondsLeftMin = 3540
                    self.secondsLeftSec = 59
                    
                } else{
                    
                    self.reset()
                    timer.invalidate()
                    
                }
            case 1...59:
                
                self.secondsLeftSec -= 1
            default:
                print("Error")
                
            }
        })
    }
    
    
    func reset(){
        self.player?.stop()
        self.timerMode = .initial
        self.secondsLeftSec = UserDefaults.standard.integer(forKey: "timerLenghtSec")
        self.secondsLeftMin = UserDefaults.standard.integer(forKey: "timerLenghtMin")
        self.secondsLeftHour = UserDefaults.standard.integer(forKey: "timerLenghtHour")
        timer.invalidate()
    }
    
    func pause(){
        self.timerMode = .paused
        timer.invalidate()
    }
    func playSound(soundName: String?) {
        
        let url = Bundle.main.url(forResource: "05446", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
    }
}
