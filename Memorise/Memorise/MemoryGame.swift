//
//  MemoryGame.swift
//  Memorise
//
//  Created by Sabir Myrzaev on 23.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card){
    print("Card chosen: \(card)")
        let chosenIndex: Int = self.index(of: card)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
    
    func index(of card: Card) -> Int{
        for index in 0..<self.cards.count{
            if self.cards[index].id == card.id{
                return index
            }
        }
        return 0 // TODO: bounds!
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for indexPair in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(indexPair)
            cards.append(Card(content: content, id: indexPair*2))
            cards .append(Card(content: content, id: indexPair*2+1))
            cards.shuffle()
            
        }
    }
    
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
