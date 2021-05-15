//
//  TImeManager.swift
//  TimerApp
//
//  Created by Sabir Myrzaev on 29.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject{
    
    
    @Published var timerMode: TimerMode = .initial
    
    
    @Published var secondsLeft = UserDefaults.standard.integer(forKey: "timerLenght")
    
    var timer = Timer()
    
    
    func setTimerLength(minutes: Int) {
        let defaults = UserDefaults.standard
        defaults.set(minutes, forKey: "timerLength")
        secondsLeft = minutes
    }
    
    func start() {
        timerMode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.secondsLeft == 0 {
                self.reset()
            }
            self.secondsLeft -= 1
        })
    }
    
    
    func reset(){
        
        self.timerMode = .initial
        self.secondsLeft = UserDefaults.standard.integer(forKey: "timerLenght")
        timer.invalidate()
    }
    
    func pause(){
        self.timerMode = .paused
        timer.invalidate()
    }
    
}



