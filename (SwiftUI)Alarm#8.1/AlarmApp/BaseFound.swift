//
//  BaseFound.swift
//  AlarmApp
//
//  Created by Sabir Myrzaev on 01.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation

enum TimerMode {
    
    case running
    case paused
    case again
    case initial
    
}

func secondsToMinutesAndSeconds(momentHour: Int, momentMin: Int, momentSec: Int) -> String{
    
    // эквивалент
    // let hours = "\((seconds % 86400) / 3600)"
    // let minutes  = "\((seconds % 3600) / 60)"
    
    
    let hours = "\(momentHour / 3600)"
    let minutes = "\(momentMin / 60 % 60)"
    let seconds = "\((momentSec % 3600) % 60)"
    
    // Выводят время 00:00:00
    
    let hoursStamp = hours.count > 1 ? hours: "0" + hours
    let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
    let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
    
    return "\(hoursStamp) : \(minuteStamp) : \(secondStamp)"
}
