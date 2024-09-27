//
//  BaccartViewModel.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation
import SwiftUI

class BaccaratViewModel: ObservableObject {
    
    var game = BaccaratModel()
    
    
    static var cardsPosition: [CGPoint] = [.zero, .zero, .zero, .zero, .zero, .zero]
    static var discardPilePosition: CGPoint = .zero
    static var shoeStackPosition: CGPoint = .zero
    
//    // MARK: - animation
//    func changeCardOffset() {
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        BaccaratViewModel.game.atHandCard[0].cardPosition = CardsPositions.onHand
//        
//    }
    
//    @State private var offset: CGSize = .zero
//    public var Offset: CGSize {
//        get {
//            return offset
//        }
//        set {
//            offset = newValue
//        }
//    }
//    
//
    
    func drawCards() {
        game.drawCards()
        //updateCardImage()
        drawToHands()
        
    }
    
    // func to clear the banker and player card to discardpile for new bet
    func clearHands() {
        game.clearHands()
    }
    
    /// This function change the betting amout
    /// - Parameter change: amount of change( positive or negative
    func changeBettingAmount(_ change: Int) {
        game.changeBettingAmount(change: change)
    }
    
    
    
    // image names of cards to be presend to the user
    @Published var playerCard1 = Card()
    @Published var playerCard2 = Card()
    @Published var playerCard3 = Card()
    
    @Published var bankerCard1 = Card()
    @Published var bankerCard2 = Card()
    @Published var bankerCard3 = Card()
    
    
    
    // func updatePositionToHands change the position from shoe stack to the Hand
    func drawToHands() {
        game.atHandCard[0].cardPosition = CardsPositions.onHand
        game.atHandCard[1].cardPosition = CardsPositions.onHand
        game.atHandCard[2].cardPosition = CardsPositions.onHand
        game.atHandCard[3].cardPosition = CardsPositions.onHand
        game.atHandCard[4].cardPosition = CardsPositions.onHand
        game.atHandCard[5].cardPosition = CardsPositions.onHand
    }
    
    /// function UpdateCardImage assigns new new images to the image object to update UI
    func updateCardImage() {
        
        playerCard1 = game.atHandCard[0]
        playerCard2 = game.atHandCard[1]
        playerCard3 = game.atHandCard[2]
        
        bankerCard1 = game.atHandCard[3]
        bankerCard2 = game.atHandCard[4]
        bankerCard3 = game.atHandCard[5]
    }
    
    
    
}
