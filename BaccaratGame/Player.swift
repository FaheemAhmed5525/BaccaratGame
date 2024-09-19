//
//  Player.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation


struct Player {
    var playerNum: Int
    var betOnTie: Int = 0
    var betOnBanker: Int = 0
    var betOnPlayer: Int = 0
    
    
}

enum stackTapOption {
    case selected
    case saved
}

enum betStacks {
    case tie
    case banker
    case player
    case noStack
}

enum CardsStates {
    case notShown
    case faceHidden
    case faceUp
}

struct Card {
    var cardValue: Int
    var cardState: CardsStates
    
    init() {
        self.cardValue = 0
        self.cardState = CardsStates.notShown
    }
    
    init(cardValue: Int, cardState: CardsStates) {
        self.cardValue = cardValue
        self.cardState = cardState
    }
}
