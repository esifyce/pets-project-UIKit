//
//  BaseFound.swift
//  TimerApp
//
//  Created by Sabir Myrzaev on 29.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation

enum TimerMode {
    
    case running
    case paused
    case initial
    
}

func secondsToMinutesAndSeconds(moment: Int) -> String{
    

    let minutes  = "\((moment % 3600) / 60)"
    
    //let minutes = "\(moment / 60 % 60)"
    let seconds = "\((moment % 3600) % 60)"
    
    
   
    let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
    let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
    
    return "\(minuteStamp) : \(secondStamp)"
}
