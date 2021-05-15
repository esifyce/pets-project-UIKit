//
//  ContentView.swift
//  AlarmApp
//
//  Created by Sabir Myrzaev on 01.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var timerManager = TimerManager()

    @State var timerMode: TimerMode = .initial

    @State var hourSelection = 0

    @State var minuteSelection = 0

    @State var secondSelection = 0

    var hours = [Int](0..<24)
    var minutes = [Int](0..<60)
    var seconds = [Int](0..<60)
    
    var body: some View {
        
        NavigationView{
            VStack {

                // верхнее време
                HStack{
                    VStack{
                Text("Будильник зазвонит через:")
                Text("\(secondsToMinutesAndSeconds(momentHour: timerManager.secondsLeftHour, momentMin: timerManager.secondsLeftMin, momentSec: timerManager.secondsLeftSec))")
                    }
                    .padding()
                    Spacer()

                    Image(systemName: timerManager.timerMode == .running ? "pause.circle.fill": "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                        .onTapGesture(perform: {

                        if self.timerManager.timerMode == .initial{
                            // заполнение времени
                            self.timerManager.setTimerLengthHour(hours: (self.hours[self.hourSelection] * 3600))
                            self.timerManager.setTimerLengthMin(minutes: self.minutes[self.minuteSelection] * 60)
                            self.timerManager.setTimerLengthSec(seconds: (self.seconds[self.secondSelection]))
                        }
                        // реализация отсчета
                        self.timerManager.timerMode == .running ? self.timerManager.pause() : self.timerManager.start()
                    })
                        Image(systemName: "stop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .onTapGesture(perform: {

                            self.timerManager.reset()
                        })
                    .padding()
                }
                .background(Color.gray)
                .cornerRadius(50)
                
                // центральное время
                Text("\(secondsToMinutesAndSeconds(momentHour: timerManager.secondsLeftHour, momentMin: timerManager.secondsLeftMin, momentSec: timerManager.secondsLeftSec))")
                    .font(.system(size: 80))
                    .padding(.top, 80)

                // кнопка запуска
                Image(systemName: timerManager.timerMode == .running ? "pause.circle.fill": "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .foregroundColor(Color.red)
                    .onTapGesture(perform: {

                        if self.timerManager.timerMode == .initial{
                            // заполнение времени
                            self.timerManager.setTimerLengthHour(hours: (self.hours[self.hourSelection] * 3600))
                            self.timerManager.setTimerLengthMin(minutes: self.minutes[self.minuteSelection] * 60)
                            self.timerManager.setTimerLengthSec(seconds: (self.seconds[self.secondSelection]))
                        }
                        // реализация отсчета
                        self.timerManager.timerMode == .running ? self.timerManager.pause() : self.timerManager.start()
                    })

                // создает кнопку, которая сбрасывает время
                if timerManager.timerMode == .paused {
                    Image(systemName: "gobackward")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding(.top, 40)
                        .onTapGesture(perform: {

                            self.timerManager.reset()
                        })
                }
                if timerManager.timerMode == .initial{

                    // дает доступ к размеру
                    GeometryReader { geometry in
                        HStack {
                            // установка часов
                            Picker(selection: self.$hourSelection, label: Text("")) {
                                ForEach(0 ..< self.hours.count) { index in
                                    Text("\(self.hours[index]) h").tag(index)
                                }
                            }
                            .frame(width: geometry.size.width/3, height: 100, alignment: .center)

                            // установка минут
                            Picker(selection: self.$minuteSelection, label: Text("")) {
                                ForEach(0 ..< self.minutes.count) { index in
                                    Text("\(self.minutes[index]) m").tag(index)
                                }
                            }
                            .frame(width: geometry.size.width/3, height: 100, alignment: .center)

                            // установка секунд
                            Picker(selection: self.$secondSelection, label: Text("")) {
                                ForEach(0 ..< self.seconds.count) { index in
                                    Text("\(self.seconds[index]) s").tag(index)
                                }
                            }
                            .frame(width: geometry.size.width/3, height: 100, alignment: .center)

                        }
                    }
                        .labelsHidden() // скрывает выборку времени
                }
                Spacer()
            }
            .navigationBarTitle("Alarm Clock")
            Text("Alex")


        }
            .environment(\.colorScheme, .light) // меняет на темную тему

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
