//
//  ContentView.swift
//  Memorise
//
//  Created by Sabir Myrzaev on 23.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewController = EmojiMemoryGames()
        var body: some View {
            
        HStack{
            
            ForEach(viewController.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewController.choose(card: card)
                }
 
            }
            

        }
            
            .padding()
             .foregroundColor(Color.orange)
            
    }
}





struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View{
        ZStack{
            
            if self.card.isFaceUp{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                
                Text(self.card.content)
            }
            else {
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color.orange)
            }
        }
        .font(Font.system(size: min(size.width, size.height) * fontScaleFactor))
    }
    // Constant
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewController: EmojiMemoryGames())
    }
}
