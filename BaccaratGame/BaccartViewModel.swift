//
//  BaccartViewModel.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation

class BaccaratViewModel: ObservableObject {
    
    static var game = BaccaratModel()
    
    
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
    @Published var playerCardImage1 = "Card0"
    @Published var playerCardImage2 = "Card0"
    @Published var playerCardImage3 = "Card0"
    
    @Published var bankerCardImage1 = "Card0"
    @Published var bankerCardImage2 = "Card0"
    @Published var bankerCardImage3 = "Card0"
    
    
    /// function UpdateCardImage assigns new new images to the image object to update UI
    func updateCardImage() {
        
        playerCardImage1 = "Card\(BaccaratViewModel.game.playerHandCard1.cardValue)"
        playerCardImage2 = "Card\(BaccaratViewModel.game.playerHandCard2.cardValue)"
        playerCardImage3 = "Card\(BaccaratViewModel.game.playerHandCard3.cardValue)"
        
        bankerCardImage1 = "Card\(BaccaratViewModel.game.bankerHandCard1.cardValue)"
        bankerCardImage2 = "Card\(BaccaratViewModel.game.bankerHandCard2.cardValue)"
        bankerCardImage3 = "Card\(BaccaratViewModel.game.bankerHandCard3.cardValue)"
    }
    
}
