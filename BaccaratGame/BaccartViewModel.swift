//
//  BaccartViewModel.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation
import SwiftUI

class BaccaratViewModel: ObservableObject {
    
    @Published var game = BaccaratModel()
    
    // image names of cards to be presend to the user
    @Published var playerCard1 = Card()
    @Published var playerCard2 = Card()
    @Published var playerCard3 = Card()
    
    @Published var bankerCard1 = Card()
    @Published var bankerCard2 = Card()
    @Published var bankerCard3 = Card()
    
    
    
    static var cardsPosition: [CGPoint] = [.zero, .zero, .zero, .zero, .zero, .zero]
    static var isDefaultPositionSet = [false, false, false, false, false, false]
    static var discardPilePosition: CGPoint = .zero
    static var isDiscardPositionSet = false
    static var shoeStackPosition: CGPoint = .zero
    static var isShoeStackPositionSet = false
    

    
    func drawCards() {
////        game.drawCards()
////        updateCardImage()
////        drawToHands()
//        
//        print("drawing cards")
//        
//        //get a unused card
//        //place first card on player hand
//        game.atHandCard[0] = game.drawNewCard()
//        game.atHandCard[0].cardPosition = .onHand
//        
//        
//        //get a unused card
//        //place first card on player hand
//        game.atHandCard[1] = game.drawNewCard()
//        game.atHandCard[1].cardPosition = .onHand
//        
////        //get a empty card
////        //place third card on player hand
////        atHandCard[3] = Card()
//        
//        //get a unused card
//        //place second card on banker hand
//        game.atHandCard[3] = game.drawNewCard()
//        game.atHandCard[3].cardPosition = .onHand
//        
//        //get a unused card
//        //place second card on banker hand
//        game.atHandCard[4] = game.drawNewCard()
//        game.atHandCard[4].cardPosition = .onHand
//        
//        
//        
//        
        
        print("Player Card 1: \(game.atHandCard[0].cardValue)");
        print("Player Card 2: \(game.atHandCard[1].cardValue)");
        print("Player Card 3: \(game.atHandCard[2].cardValue)");
        print("Banker Card 1: \(game.atHandCard[3].cardValue)");
        print("Banker Card 2: \(game.atHandCard[4].cardValue)");
        print("Banker Card 3: \(game.atHandCard[5].cardValue)");
        
        
        playerCard1 = game.atHandCard[0];
        playerCard1 = game.atHandCard[1];
        playerCard1 = game.atHandCard[3];
        playerCard1 = game.atHandCard[4];
        
        var result = game.checkCards();
        
        game.dealCards();
    }
    
    
    
    // func to clear the banker and player card to discardpile for new bet
    func clearHands() {
        game.clearHands()
    }
    
    /// This function change the betting amout
    /// - Parameter change: amount of change( positive or negative
    func changeBettingAmount(_ change: Int) {
        game.changeBettingAmount(change: change)
        print("changing bettingAmount with: \(change)")
    }
    
    /// This func returns updated valued of BettingAmount
    func getBettingAmount()-> Int {
        print("getting bettingAmount value: \(game.bettingAmount)")
        return game.bettingAmount
    }
    
    func stackTapped(playerIndex: Int, bettingStack: betStacks) {
        game.stackTapped(playerIndex: playerIndex, bettingStack: bettingStack)
        print("Stack tapped with index: \(playerIndex) and betting Stack\(bettingStack == betStacks.tie ? "Tie" : (bettingStack == betStacks.banker ? "Banker" : "Player" ))")
    }
    
    
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
