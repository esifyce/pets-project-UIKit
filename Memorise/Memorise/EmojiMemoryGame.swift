//
//  EmojiMemoryGame.swift
//  Memorise
//
//  Created by Sabir Myrzaev on 23.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI


class EmojiMemoryGames: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGames.createMemoryGame()
        
    static func createMemoryGame() -> MemoryGame<String>{
        let emoji: Array<String> = ["👻","🎃", "🕷", "🕸", "🥧","😀","😃","😄","😁","😆"].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) { indexPair in
            return emoji[indexPair]
        }

    }
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    func choose(card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
}
