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
    
    @Published var gameResult = DealResult.needAnotherCard;
    
    static var cardsPosition: [CGPoint] = [.zero, .zero, .zero, .zero, .zero, .zero]
    static var isDefaultPositionSet = [false, false, false, false, false, false]
    static var discardPilePosition: CGPoint = .zero
    static var isDiscardPositionSet = false
    static var shoeStackPosition: CGPoint = .zero
    static var isShoeStackPositionSet = false
    
    var playersBankroll: Array<Int> = [0, 0, 0, 0, 0, 0]
    

    
    func drawCards() {
        
        print("drawing cards")
        game.drawFirstHandCards();
 
        
        playerCard1 = game.atHandCard[0];
        playerCard2 = game.atHandCard[1];
        bankerCard1 = game.atHandCard[3];
        bankerCard2 = game.atHandCard[4];
        
        let result = game.checkCards();
        
        if result != DealResult.needAnotherCard {
            gameResult = result;
            print("------------Game State: \(result)")
        }
        else {
            gameResult = game.dealAgain()
            playerCard3 = game.atHandCard[2]
            bankerCard3 = game.atHandCard[5]
            print("++++++++++++Game State: \(gameResult)")
        }
        
        
        print("Player Card 1: \(game.atHandCard[0].cardValue)");
        print("Player Card 2: \(game.atHandCard[1].cardValue)");
        print("Player Card 3: \(game.atHandCard[2].cardValue)");
        print("Banker Card 1: \(game.atHandCard[3].cardValue)");
        print("Banker Card 2: \(game.atHandCard[4].cardValue)");
        print("Banker Card 3: \(game.atHandCard[5].cardValue)");
        
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
        
        
        print("updating imges")
        playerCard1 = game.atHandCard[0]
        playerCard2 = game.atHandCard[1]
        playerCard3 = game.atHandCard[2]
        
        bankerCard1 = game.atHandCard[3]
        bankerCard2 = game.atHandCard[4]
        bankerCard3 = game.atHandCard[5]
    }
    
    func getResultTitle() -> String {
        if gameResult == DealResult.tie {
            return "It tie! \n"
        }
        else if gameResult == DealResult.bankerWin {
            return "Banker wins!"
        }
        else {
            return "Player wins!"
        }
    }
    
    func getResultString() -> String {
        var result = ""
        
        if gameResult == DealResult.tie {
            for (index, player) in game.players.enumerated() {
                if player.betOnPlayer > 0 {
                    result += "Player at player \(index + 1) pushes \(player.betOnPlayer).\n"
                }
                if player.betOnBanker > 0 {
                    result += "Player at banker \(index + 1) pushes \(player.betOnBanker).\n"
                }
            }
        } else if gameResult == DealResult.bankerWin {
            for (index, player) in game.players.enumerated() {
                if player.betOnPlayer > 0 {
                    result += "Player at player \(index + 1) pushes \(player.betOnPlayer).\n"
                }
                if player.betOnBanker > 0 {
                    let payout = player.betOnBanker * 2
                    result += "Player at banker \(index + 1) gets \(payout).\n"
                }
            }
        } else if gameResult == DealResult.playerWin {
            for (index, player) in game.players.enumerated() {
                if player.betOnPlayer > 0 {
                    let payout = player.betOnPlayer * 2
                    result += "Player at player \(index + 1) gets \(payout).\n"
                }
                if player.betOnBanker > 0 {
                    result += "Player at banker \(index + 1) pushes \(player.betOnBanker).\n"
                }
            }
        }
        
        return result
    }

    
}
