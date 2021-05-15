//
//  ContentView.swift
//  slotsUI
//
//  Created by Sabir Myrzaev on 18.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    
    @State private var symbols = ["apple", "cherry", "donut", "seven1"]
    @State private var numbers = [0, 1, 2, 3]
    @State private var isCredits = 0
    @State private var backgrounds = [Color.white, Color.white, Color.white]
    var body: some View {
        
        ZStack{
            Rectangle().foregroundColor(Color(red: 200/255, green: 143/255, blue: 25/255)).edgesIgnoringSafeArea(.all)
            
            Rectangle().foregroundColor(Color(red: 228/255, green: 195/255, blue: 76/255)).rotationEffect(Angle(degrees: 45)).edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
            HStack{
                
                //title
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("Casino Slots").foregroundColor(.white).fontWeight(.heavy)
                                Image(systemName: "star.fill").foregroundColor(.yellow)
        
                }.scaleEffect(2)
                
               Spacer()
                //Credit counter
                
                Text("Попыток: " + String(isCredits)).foregroundColor(.black)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5)).cornerRadius(20)
                
                Spacer()
                //Cards
                HStack{
                    
                   Spacer()
                    
                    CardView(symbols: $symbols[numbers[0]], background: $backgrounds[0])
                    
                    CardView(symbols: $symbols[numbers[1]], background: $backgrounds[1])
                    
                    CardView(symbols: $symbols[numbers[2]], background: $backgrounds[2])


                    Spacer()
                }
                //Button

                Spacer()
                Button(action: {
                    self.backgrounds = self.backgrounds.map({ _ in
                        Color.white
                    })
                    self .isCredits += 1
                    self.numbers = self.numbers.map({_ in
                        Int.random(in: 0...self.symbols.count - 1)
                    })
                    
                    if self.numbers[0] == self.numbers[1] && self.numbers[1] == self.numbers[2]{
                        
                        self.backgrounds = self.backgrounds.map({ _ in
                            Color.green
                        })

                    }
                    
                }) {
                    //spin
                    Text("Spin").foregroundColor(.white)
                        .padding(.all, 10)
                        .padding([.leading, .trailing], 30)
                        .background(Color.pink).cornerRadius(20)
                    
                    
                }
                Spacer()
                
                
                
            }
            
        }
        
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
