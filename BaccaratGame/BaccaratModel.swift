//
//  BaccaratModel.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import Foundation

struct BaccaratModel {
    
    var selectedPlayerIndex: Int = 10                      //Index is change to a player's stack when he taps a stack
    var selectedStack: betStacks = betStacks.noStack  //no stack is selected by default
    
    var bettingAmount: Int = 0
    let emptyCard = Card()
    
    var card: [Int: Bool] = Dictionary(uniqueKeysWithValues: (1...52).map {($0, false) })
    
    
    /// These var will be used for calculation of  resulat and also to show card on screen in Player's and Banker's hand
    var atHandCard = Array(repeating: Card(), count: 6)
    
    
    
    
    
    var players: Array<Player> = [Player(playerNum: 1), Player(playerNum: 2), Player(playerNum: 3), Player(playerNum: 4)]
    
    
    mutating func changeBettingAmount(change: Int) {
        if (bettingAmount + change) > 20 || change > 0 {
            bettingAmount += change
        }
    }
    
    
    /// Action to taked when a stack is tapped by user
    /// - Parameters:
    ///   - playerIndex: index of the player who tapped his betting area
    ///   - bettingStack: the stack which tapped, (tie, banker, or player)
    mutating func stackTapped(playerIndex: Int, bettingStack: betStacks) {
        
        // Checking if any already selected betStack is open
        if selectedPlayerIndex < players.count {
            
            //checking if the selected Player is same as the tapped
            /// To be updated
            if selectedPlayerIndex == playerIndex-1 {
                
                //checkingif the selected stack is same as tapped
                if selectedStack == bettingStack {
                    
                    //Saving the betting amount for closing bet stack
                    if bettingStack == betStacks.tie {
                        players[selectedPlayerIndex].betOnTie = bettingAmount
                        
                    } else if bettingStack == betStacks.banker {
                        players[selectedPlayerIndex].betOnBanker = bettingAmount
                        
                    } else if bettingStack == betStacks.player {
                        players[selectedPlayerIndex].betOnPlayer = bettingAmount
                        
                    } else {
                        //No Cas
                    }
                    
                    
                    //clearing the betting amount values
                    bettingAmount = 0
                    selectedPlayerIndex = 10
                    selectedStack = betStacks.noStack
                    return
                }
                
                // another closed stack of same player is taped
                else {
                    
                    //Saving the betting amount for closing bet stack
                    if bettingStack == betStacks.tie {
                        bettingAmount = players[selectedPlayerIndex].betOnTie
                        
                    } else if bettingStack == betStacks.banker {
                        bettingAmount = players[selectedPlayerIndex].betOnBanker
                        
                    } else if bettingStack == betStacks.player {
                        bettingAmount = players[selectedPlayerIndex].betOnPlayer
                        
                    }
                }
            }
            
            // another closed stack is taped
            else {
                
                //Saving the betting amount for closing bet stack
                if bettingStack == betStacks.tie {
                    players[selectedPlayerIndex].betOnTie = bettingAmount
                    
                } else if bettingStack == betStacks.banker {
                    players[selectedPlayerIndex].betOnBanker = bettingAmount
                    
                } else if bettingStack == betStacks.player {
                    players[selectedPlayerIndex].betOnPlayer = bettingAmount
                    
                }
                
                
                
            }
        }
        
        // settting the tapepd stack as selected
        selectedPlayerIndex = playerIndex - 1
        selectedStack = bettingStack
        
        if bettingStack == betStacks.tie {
            bettingAmount = players[selectedPlayerIndex].betOnTie
            
        } else if bettingStack == betStacks.banker {
            bettingAmount = players[selectedPlayerIndex].betOnBanker
            
        } else if bettingStack == betStacks.player {
            bettingAmount = players[selectedPlayerIndex].betOnPlayer
        }
        
    }
    
    
    mutating func drawFirstHandCards() {
        //get a unused card
        //place first card on player hand
        atHandCard[0] = drawNewCard()
        atHandCard[0].cardPosition = .onHand
        
        
        //get a unused card
        //place first card on player hand
        atHandCard[1] = drawNewCard()
        atHandCard[1].cardPosition = .onHand
        
//        //get a empty card
//        //place third card on player hand
//        atHandCard[3] = Card()
        
        //get a unused card
        //place second card on banker hand
        atHandCard[3] = drawNewCard()
        atHandCard[3].cardPosition = .onHand
        
        //get a unused card
        //place second card on banker hand
        atHandCard[4] = drawNewCard()
        atHandCard[4].cardPosition = .onHand
    }
    
    func checkCards() -> DealResult {
        
        let playerTotal: Int = ((atHandCard[0].cardValue % 13) + (atHandCard[1].cardValue % 13)) % 10
        let bankerTotal: Int = ((atHandCard[3].cardValue % 13) + (atHandCard[4].cardValue % 13)) % 10
        
        //if the care is tie
        if playerTotal == bankerTotal {
            handleTie()
            print("Banker total: \(bankerTotal)")
            print("Player total: \(playerTotal)")
            return DealResult.tie;
        }
        else if playerTotal == 8 || playerTotal == 9 {
            if playerTotal > bankerTotal {
                handlePlayerWin()
                return DealResult.playerWin;
            }
            
        }
        else if bankerTotal == 8 || bankerTotal == 9 {
            if bankerTotal > playerTotal {
                handleBankerWin()
                return DealResult.bankerWin
            }
        }
        
        return DealResult.needAnotherCard;
    }
    
    
    mutating func dealAgain() -> DealResult {
        
        var playerTotal: Int = ((atHandCard[0].cardValue % 13) + (atHandCard[1].cardValue % 13)) % 10
        var bankerTotal: Int = ((atHandCard[3].cardValue % 13) + (atHandCard[4].cardValue % 13)) % 10
        
        if playerTotal <= 5 {
            
            //draws a third card
            atHandCard[2] = drawNewCard()
            atHandCard[2].cardPosition = .onHand
            playerTotal = ((atHandCard[0].cardValue % 13) + (atHandCard[1].cardValue % 13) + (atHandCard[2].cardValue) % 13) % 10
        }
        
        let playerThirdCard = ((atHandCard[2].cardValue) % 13) % 10
        
        //Condition when banker draws third card
        if (bankerTotal >= 0 && bankerTotal <= 2) ||
            (bankerTotal == 3 && playerTotal != 8 ) ||
            (bankerTotal == 4 && (playerThirdCard >= 2 && playerThirdCard <= 7)) ||
            (bankerTotal == 5 && (playerThirdCard >= 4 && playerThirdCard <= 7)) ||
            (bankerTotal == 6 && (playerThirdCard == 6 || playerThirdCard == 7)) {
            
            atHandCard[5] = drawNewCard()
            atHandCard[5].cardPosition = .onHand
            
            bankerTotal = ((atHandCard[3].cardValue % 13) + (atHandCard[4].cardValue % 13) + (atHandCard[5].cardValue % 13)) % 10
        }
        
        //if the case is tie
        if playerTotal == bankerTotal {
            return DealResult.tie
            
        }
        // player won
        else if playerTotal > bankerTotal {
            return DealResult.playerWin
            
        }
        // banker won
        else {
            return DealResult.bankerWin
        }
    
    }
    
    
    
    /// dealCards  function is executed after the initial cards are drawn
    mutating func dealCards() {
        var playerTotal: Int = ((atHandCard[0].cardValue % 13) + (atHandCard[1].cardValue % 13)) % 10
        var bankerTotal: Int = ((atHandCard[3].cardValue % 13) + (atHandCard[4].cardValue % 13)) % 10
        
        //if the care is tie
        if playerTotal == bankerTotal {
            handleTie()
            print("Banker total: \(bankerTotal)")
            print("Player total: \(playerTotal)")
            return
        }
        else if playerTotal == 8 || playerTotal == 9 {
            if playerTotal > bankerTotal {
                handlePlayerWin()
                return
            }
            
        }
        else if bankerTotal == 8 || bankerTotal == 9 {
            if bankerTotal > playerTotal {
                handleBankerWin()
                return
            }
        }
        else if playerTotal <= 5 {
            
            //draws a third card
            atHandCard[2] = drawNewCard()
            atHandCard[2].cardPosition = .onHand
            playerTotal = ((atHandCard[0].cardValue % 13) + (atHandCard[1].cardValue % 13) + (atHandCard[2].cardValue) % 13) % 10
            
        }
        let playerThirdCard = ((atHandCard[2].cardValue) % 13) % 10
        
        //Condition when banker draws third card
        if (bankerTotal >= 0 && bankerTotal <= 2) ||
            (bankerTotal == 3 && playerTotal != 8 ) ||
            (bankerTotal == 4 && (playerThirdCard >= 2 && playerThirdCard <= 7)) ||
            (bankerTotal == 5 && (playerThirdCard >= 4 && playerThirdCard <= 7)) ||
            (bankerTotal == 6 && (playerThirdCard == 6 || playerThirdCard == 7)) {
            
            atHandCard[5] = drawNewCard()
            atHandCard[5].cardPosition = .onHand
            
            bankerTotal = ((atHandCard[3].cardValue % 13) + (atHandCard[4].cardValue % 13) + (atHandCard[5].cardValue % 13)) % 10
        }
        
        //if the case is tie
        if playerTotal == bankerTotal {
            handleTie()
            
        }
        // player won
        else if playerTotal > bankerTotal {
            handlePlayerWin()
            
        }
        // banker won
        else {
            handleBankerWin()
        }
        
    }
    
    
    /// draw card is called to draw a new card for cardShoe
    mutating func drawNewCard()-> Card {
        
        var randomNum = Int.random(in: 1...52)
        
        //get a unused card
        while card[randomNum] == true {
            print("Number failed: \(randomNum)")
            randomNum = Int.random(in: 1...52)
        }
        
        //place first card on player hand
        card[randomNum] = true
        
        
        return Card(cardValue: randomNum, cardState: CardsStates.faceHidden)
    }

    
    // Clear the handscard
    mutating func clearHands() {
        for index in 0..<6 {
            atHandCard[index] = emptyCard
        }
        
    }
    
    
    // handleTie is called where tie occurs while dealing cards
    func handleTie() {
        print("It tie!")
    }
    
    // handlePlayerWin() is called where the player wins
    func handlePlayerWin() {
        print("Player won the game")
    }
    
    // handleBankerWin() is called where the banker wins
    func handleBankerWin() {
        print("Banker won the game")
        
    }
}


enum DealResult {
    case playerWin
    case bankerWin
    case tie
    case needAnotherCard
    case wait
}
