//
//  BaccaratView.swift
//  BaccaratGame
//
//  Created by Faheeam Ahmed on 18/09/2024.
//

import SwiftUI

struct BaccaratView: View {
    var sidesColor = UIColor(red: 58/255, green: 146/255, blue: 24/255, alpha: 1.0)
    var centeralColor = UIColor(red: 70/255, green: 180/255, blue: 24/255, alpha: 1.0)
   
    // interaction object with Modol view
    @ObservedObject var gameView = BaccaratViewModel()
    
    @State var cardsOffset: [CGSize] = [.zero, .zero, .zero, .zero, .zero, .zero]
    @State var cardsPosition: [CGPoint] = [.zero, .zero, .zero, .zero, .zero, .zero]
    @State var discardPilePosition: CGPoint = .zero
    @State var shoeStackPosition: CGPoint = .zero
    @State var bettingAmount = 0
    
    
    var body: some View {
                
        ZStack {
            //Backgrond
            GeometryReader{ geometry in
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(UIColor.systemGray2))
            }

            GeometryReader { geometry in
                
                //Getting width and heigh with respect to current screen
                let height = geometry.size.height
                let width = height * 15/8
                
                
                
                ZStack{
                    //background rectangle
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.gray)
                        .frame(width: width, height: height)
                        .padding(12)
                    
                    VStack(alignment: .center) {
                        HStack(alignment: .top) {
                            // DiscardPile
                            GeometryReader { geometry in
                                
                                
                                DiscardPile(width: width/10, height: height/4)
                                    
                                
                            }
                            
                            VStack {
                                //coins box
                                ChipStackView(width: width/2, height: height/8)
                                
                                //Betting Amount Label
                                Text("Betting Amount: \(gameView.game.bettingAmount)")
                                
                                
                                HStack {
                                    Button("Start") {
                                        gameView.drawCards()
                                        findOffsetToShoe()
                                        withAnimation {
                                            
                                            animateCardsToHands()
                                        }
                                    }
                                    Button("Clear") {
                                        gameView.clearHands()
                                        withAnimation {
                                            animateCardsToDiscardPile()
                                        }
                                    }
                                }
                                .padding(.bottom, 0)
                                .background(Color.cyan)
                            }
                            
                            //CasinoStack(width: width, height: height)
                            // ShoeStack
                            ShoeStackView(width: width/5, height: height/4)
                                
                                
                        }
                            .padding(24)
                        
                        HStack {
                                
                                // PlayerHand
                            PlayerHandView(width: width/5, height: height/4)
                                .overlay(
                                    HStack(alignment: .center, spacing: -width/10) {
                                        CardView(cardIndex: 0, card: gameView.playerCard1, width: width/10, height: height/4)
                                            .position(cardsPosition[0])
                                        
                                        CardView(cardIndex: 1, card: gameView.playerCard2, width: width/10, height: height/4)
                                           .position(cardsPosition[1])
                                        
                                        CardView(cardIndex: 2, card: gameView.playerCard3, width: width/10, height: height/4)
                                           .position(cardsPosition[2])
                                    }
                                )
                            
                                // BankerHand
                            BankerHandView(width: width/5, height: height/4)
                                .overlay (
                                    HStack(alignment: .center, spacing: -width/10) {
                                        CardView(cardIndex: 3, card: gameView.bankerCard1, width: width/10, height: height/4)
                                            .position(cardsPosition[3])
                                        CardView(cardIndex: 4, card: gameView.bankerCard2, width: width/10, height: height/4)
                                            .position(cardsPosition[4])
                                        CardView(cardIndex: 5, card: gameView.bankerCard3, width: width/10, height: height/4)
                                            .position(cardsPosition[5])
                                    }
                                )
                        }
                        
                        //Spacer(minLength: 00)
                        Spacer()
                            BettingAmountChangeButtons
                    }
                    
                    
                    
                    //let x = geometry.frame(in: .global).origin.x
                    let y = geometry.frame(in: .global).origin.y
                    let arcCenter = CGPoint(x: width/2, y: y)
                    
                    let tieArcRadius = CGFloat(height * 5/6)
                    
                    // For player 1
                    TieAreaView(forPlayer: 1, center: arcCenter, radius: tieArcRadius, startAngle: .degrees(30), endAngle: .degrees(55))
                        .onTapGesture {
                            gameView.stackTapped(playerIndex: 1, bettingStack: betStacks.tie)
                        }
                    
                    // for Payer 2
                    TieAreaView(forPlayer: 2, center: arcCenter, radius: tieArcRadius, startAngle: .degrees(60), endAngle: .degrees(85))
                        .onTapGesture {
                            gameView.stackTapped(playerIndex: 2, bettingStack: betStacks.tie)
                        }
                    
                    
                    // For Player 3
                    TieAreaView(forPlayer: 3, center: arcCenter, radius: tieArcRadius, startAngle: .degrees(95), endAngle: .degrees(120))
                        .onTapGesture {
                            gameView.stackTapped(playerIndex: 3, bettingStack: betStacks.tie)
                        }
                    
                    
                    // for Player 4
                    TieAreaView(forPlayer: 4, center: arcCenter, radius: tieArcRadius, startAngle: .degrees(125), endAngle: .degrees(150))
                        .onTapGesture {
                            gameView.stackTapped(playerIndex: 4, bettingStack: betStacks.tie)
                        }
                    
                    // Banker betting area
                    let bankerArcRadius = CGFloat(height * 11/12)
                    //for Player 1
                    BankerAreaView(forPlayer: 1, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(30), endAngle: .degrees(55))
                        .onTapGesture {
                            gameView.stackTapped(playerIndex: 3, bettingStack: betStacks.tie)
                        }
                    
                    //for Player 2
                    BankerAreaView(forPlayer: 2, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(60), endAngle: .degrees(85))
                    
                    //for Player 3
                    BankerAreaView(forPlayer: 3, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(95), endAngle: .degrees(120))
                    
                    //for Player 4
                    BankerAreaView(forPlayer: 4, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(125), endAngle: .degrees(150))
                    
                    //Player betting are
                    let playerArcRadius = CGFloat(height)
                    //for Player 1
                    PlayerAreaView(forPlayer: 1, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(30), endAngle: .degrees(55))
                    
                    //for Player 2
                    PlayerAreaView(forPlayer: 2, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(60), endAngle: .degrees(85))
                    
                    //for Player 3
                    PlayerAreaView(forPlayer: 3, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(95), endAngle: .degrees(120))
                    
                    //for Player 4
                    PlayerAreaView(forPlayer: 4, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(125), endAngle: .degrees(150))
 
                }
                    .frame(width: width, height: height)
                    .padding(12)
                
            }
        }
    }
 

    
    /// button that allows player to set and change about of bet
    var BettingAmountChangeButtons: some View {
        return HStack {
            VStack {
                Button("+5$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(5)
                }
                Button("+20$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(20)
                }
                Button("+100$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(100)
                }
                Button("+1000$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(1000)
                }
            }

            Spacer()

            VStack {
                Button("-5$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(-5)
                }
                Button("-20$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(-20)
                }
                Button("-100$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(-100)
                }
                Button("-1000$") {
                    updateBettingAmount()
                    gameView.changeBettingAmount(-1000)
                }
            }
        }
        .padding(20)
    }
    
    func findOffsetToShoe() {
        print("--------\(BaccaratViewModel.shoeStackPosition)")
        cardsPosition[0] = BaccaratViewModel.shoeStackPosition
        cardsPosition[1] = BaccaratViewModel.shoeStackPosition
        cardsPosition[2] = BaccaratViewModel.shoeStackPosition
        cardsPosition[3] = BaccaratViewModel.shoeStackPosition
        cardsPosition[4] = BaccaratViewModel.shoeStackPosition
        cardsPosition[5] = BaccaratViewModel.shoeStackPosition

    }
    
    func animateCardsToDiscardPile() {
        cardsPosition[0] = BaccaratViewModel.discardPilePosition
        cardsPosition[1] = BaccaratViewModel.discardPilePosition
        cardsPosition[2] = BaccaratViewModel.discardPilePosition
        cardsPosition[3] = BaccaratViewModel.discardPilePosition
        cardsPosition[4] = BaccaratViewModel.discardPilePosition
        cardsPosition[5] = BaccaratViewModel.discardPilePosition

    }
    
    func animateCardsToHands() {

        cardsPosition[0] = BaccaratViewModel.cardsPosition[0]
        cardsPosition[1] = BaccaratViewModel.cardsPosition[1]
        cardsPosition[2] = BaccaratViewModel.cardsPosition[2]
        cardsPosition[3] = BaccaratViewModel.cardsPosition[3]
        cardsPosition[4] = BaccaratViewModel.cardsPosition[4]
        cardsPosition[5] = BaccaratViewModel.cardsPosition[5]

    }
    
    ///func updateBettingAmount updates the betting amount to show
    func updateBettingAmount() {
        bettingAmount = gameView.getBettingAmount()
    }
}





class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)->UIInterfaceOrientationMask {
        return .landscape
    }
}

//#Preview {
//    BaccaratView()
//}






/// Create a block to present discard pile
struct DiscardPile: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View {
            
            CardBackView(width: width, height: height)
                .padding(.trailing, 36)
                .background(GeometryReader { box in
                    Color.clear.onAppear {
                        if !BaccaratViewModel.isDiscardPositionSet {
                            BaccaratViewModel.discardPilePosition = box.frame(in: .local).origin
                            BaccaratViewModel.isDiscardPositionSet = true
                        }
                    }
                }
                )
    }
}



/// Chip Stack customization
struct ChipStackView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.yellow)
            .frame(width: width, height: height)
            .padding(.top, 0.0)
    }
}




/// Shoe Stack customization
struct ShoeStackView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.black)
                .frame(width: width, height: height)
                .padding(.leading, 24)
                .background(GeometryReader { box in
                    Color.clear.onAppear {
                        if !BaccaratViewModel.isShoeStackPositionSet {
                            BaccaratViewModel.shoeStackPosition = CGPoint(x: (box.frame(in: .local).minX), y: box.frame(in: .global).minY)
                            BaccaratViewModel.isShoeStackPositionSet = true
                        }
                    }
                }
                )
                .overlay(
                    HStack(alignment: .center, spacing: -width/2) {
                        CardBackView(width: width/2, height: height)
                        CardBackView(width: width/2, height: height)
                        CardBackView(width: width/2, height: height)
                        CardBackView(width: width/2, height: height)
                    }
                        
                )
        }
    }
}


/// Displaying Back side of the Card
struct CardBackView: View {
                    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image("CardBack")
            .resizable()
            .frame(width: width, height: height)
            .cornerRadius(8)
            .padding(.leading, 24)
    }
}

/// Player's hand cutomization
struct PlayerHandView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8.0)
            .stroke(Color.black)
            .frame(width: width, height: height)
            .padding(.trailing, 24)
            
    }
}

/// Banker's hand customization
struct BankerHandView: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8.0)
            .stroke(Color.black)
            .frame(width: width, height: height)
            .padding(.leading, 24)
    }
}


/// Betting area for Tie
struct TieAreaView: View {
    let forPlayer: Int
    let center: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle

    var body: some View {
        Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
        }
        .strokedPath(StrokeStyle(lineCap: .round))
        .stroke(Color(UIColor.systemGray4), lineWidth: 32)

    }
}




/// Betting area for Banker
struct BankerAreaView: View {
    let forPlayer: Int
    let center: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle

    var body: some View {
        Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
        }
        .strokedPath(StrokeStyle(lineCap: .round))
        .stroke(Color(UIColor.systemGray4), lineWidth: 32)
    }
}

/// Betting area for Player
struct PlayerAreaView: View {
    let forPlayer: Int
    let center: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle

    var body: some View {
        Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )

        }
        .strokedPath(StrokeStyle(lineCap: .round))
        .stroke(Color(UIColor.systemGray6), lineWidth: 32)

    }
}



struct CardView: View {
    let cardIndex: Int
    let card: Card
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(card.cardState == CardsStates.faceHidden ? "CardBack" : (card.cardState == CardsStates.faceUp ? "Card\(card.cardValue)" : "Card51"))
            .resizable()
            .frame(width: width, height: height)
            .background(GeometryReader { cardBox in
                Color.clear.onAppear {
                    if !BaccaratViewModel.isDefaultPositionSet[cardIndex] {
                        BaccaratViewModel.isDefaultPositionSet[cardIndex] = true
                        BaccaratViewModel.cardsPosition[cardIndex] = CGPoint(x: cardBox.frame(in: .global).minX - cardBox.frame(in: .global).width, y: cardBox.frame(in: .local).minY - cardBox.frame(in: .local).height)
                        
                    }
                }
            })
            .cornerRadius(8)
            .padding(.leading, 24)
            .zIndex(3)
            //.position(card.cardPosition == CardsPositions.onShoeStack ? BaccaratViewModel.shoeStackPosition : (card.cardPosition == CardsPositions.onDiscardPile ? BaccaratViewModel.discardPilePosition : BaccaratViewModel.cardsPosition[cardIndex]))
    }

}

