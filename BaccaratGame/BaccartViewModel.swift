//
//  BaccartViewModel.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation
import SwiftUI

class BaccaratViewModel: ObservableObject {
    
    static var game = BaccaratModel()
    
    static var cardsOffset: [CGSize] = [.zero, .zero, .zero, .zero, .zero, .zero]
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
    
    static func drawCards() {
        game.drawCards()
        //updateCardImage()
    }
    
    /// This function change the betting amout
    /// - Parameter change: amount of change( positive or negative
    static func changeBettingAmount(_ change: Int) {
        game.changeBettingAmount(change: change)
    }
    
    
    
    // image names of cards to be presend to the user
    @Published var playerCard1 = BaccaratViewModel.game.atHandCard[0]
    @Published var playerCard2 = BaccaratViewModel.game.atHandCard[1]
    @Published var playerCard3 = BaccaratViewModel.game.atHandCard[2]
    
    @Published var bankerCard1 = BaccaratViewModel.game.atHandCard[3]
    @Published var bankerCard2 = BaccaratViewModel.game.atHandCard[4]
    @Published var bankerCard3 = BaccaratViewModel.game.atHandCard[5]
    
    
    /// function UpdateCardImage assigns new new images to the image object to update UI
    func updateCardImage() {
        
        playerCard1 = BaccaratViewModel.game.atHandCard[0]
        playerCard2 = BaccaratViewModel.game.atHandCard[1]
        playerCard3 = BaccaratViewModel.game.atHandCard[2]
        
        bankerCard1 = BaccaratViewModel.game.atHandCard[3]
        bankerCard2 = BaccaratViewModel.game.atHandCard[4]
        bankerCard3 = BaccaratViewModel.game.atHandCard[5]
    }
    
}
