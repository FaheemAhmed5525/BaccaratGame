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
    @State var discardPilePosition: CGPoint = .zero
    @State var shoeStackPosition: CGPoint = .zero
    @State var bettingAmount = 0
    @State var cardsOpecity = 0.0
    @State var betsOnTie: [Int64] = [0, 0, 0, 0]
    @State var betsOnBanker: [Int64] = [0, 0, 0, 0]
    @State var betsOnPlayer: [Int64] = [0, 0, 0, 0]
    
    @State var isAnyStackOpen = false
    @State var isShowingResult = false
    
    private var animationDuration: TimeInterval = 0.0
    @State private var animationDurationOffset: TimeInterval = 0.0
    var animationStartTime: TimeInterval {
        animationDuration + animationDurationOffset
    }
    
    
    
    
    var body: some View {
        ZStack {
            // Background
            GeometryReader { geometry in
                ZStack {
                    // Solid background color
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray2))
                        .edgesIgnoringSafeArea(.all)
                    
                    // Background image
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                //        }
                //
                //        // Main content
                //        GeometryReader { geometry in
                
                let height = geometry.size.height
                let width = height * 15 / 8
                
                ZStack {
                    //                // Background rectangle
                    //                RoundedRectangle(cornerRadius: 25.0)
                    //                    .fill(.gray)
                    //                    .frame(width: width, height: height)
                    //                    .opacity(0.5)
                    //                    .padding(.horizontal, 12)
                    
                    
                    VStack(alignment: .center) {
                        HStack(alignment: .top) {
                            // DiscardPile
                            GeometryReader { geometry in
                                
                                DiscardPile(width: width/10, height: height/4)
                                
                            }
                            
                            VStack {
                                //coins box
                                ChipStackView(width: width/2, height: height/8)
                                    .overlay {
                                        if isShowingResult {
                                            VStack() {
                                                Text(gameView.getResultTitle())
                                                    .font(.headline)
                                                    .foregroundColor(.green)
                                                
                                                Text(gameView.getResultString())
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
                                            .frame(minWidth: 420, minHeight: 125)
                                            .zIndex(3)
                                            .background(Color.white)
                                            .cornerRadius(8.0)
                                            .shadow(radius: 8.0)
                                            
                                            
                                        }
                                    }
                                
                                //Betting Amount Label
                                Text("Betting Amount: \(bettingAmount)")
                                    .zIndex(1.0)
                                
                                
                                HStack {
                                    Button("Start") {
                                        findOffsetToShoe()
                                        cardsOpecity = 1.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            gameView.drawCards()
                                            animateCardsToHands();
                                        }
                                    }
                                    .disabled(isAnyStackOpen || isShowingResult)
                                    .padding()
                                    .frame(width: 72, height: 32)
                                    .background(isAnyStackOpen || isShowingResult ? Color.gray: Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.4), radius: 6, x: 3, y: 3)
                                    //.buttonStyle(CustomButtonStyle(isDisabled: isAnyStackOpen || isShowingResult))
                                    
                                    Button("Clear") {
                                        gameView.clearHands()
                                        withAnimation {
                                            animateCardsToDiscardPile()
                                            cardsOpecity = 0.0;
                                        }
                                        gameView.clearBets()
                                        isShowingResult = false
                                    }
                                    .disabled(!isShowingResult)
                                    .padding()
                                    .frame(width: 72, height: 32)
                                    .background(!isShowingResult ? Color.gray: Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.4), radius: 6, x: 3, y: 3)
//                                    .buttonStyle(CustomButtonStyle(isDisabled: !isShowingResult))
                                }
                                
                            }
                            
                            // ShoeStack
                            ShoeStackView(width: width/5, height: height/4)
                            
                            
                        }
                        .padding(24)
                        
                        HStack {
                            
                            // PlayerHand
                            PlayerHandView(width: width/6, height: height/4)
                                .overlay(
                                    HStack(alignment: .center, spacing: -width/10) {
                                        CardView(cardIndex: 0, card: gameView.playerCard1, width: width/10, height: height/4)
                                            .offset(cardsOffset[0])
                                            .opacity(cardsOpecity)
                                        
                                        CardView(cardIndex: 1, card: gameView.playerCard2, width: width/10, height: height/4)
                                            .offset(cardsOffset[1])
                                            .opacity(cardsOpecity)
                                        
                                        CardView(cardIndex: 2, card: gameView.playerCard3, width: width/10, height: height/4)
                                            .offset(cardsOffset[2])
                                            .opacity(cardsOpecity)
                                    }
                                )
                            
                            // BankerHand
                            BankerHandView(width: width/6, height: height/4)
                                .overlay (
                                    HStack(alignment: .center, spacing: -width/10) {
                                        CardView(cardIndex: 3, card: gameView.bankerCard1, width: width/10, height: height/4)
                                            .offset(cardsOffset[3])
                                            .opacity(cardsOpecity)
                                        //.position(cardsPosition[3])
                                        CardView(cardIndex: 4, card: gameView.bankerCard2, width: width/10, height: height/4)
                                            .offset(cardsOffset[4])
                                            .opacity(cardsOpecity)
                                        //.position(cardsPosition[4])
                                        CardView(cardIndex: 5, card: gameView.bankerCard3, width: width/10, height: height/4)
                                            .offset(cardsOffset[5])
                                            .opacity(cardsOpecity)
                                        // .position(cardsPosition[5])
                                    }
                                )
                        }
                        
                        //Spacer(minLength: 00)
                        Spacer()
                        BettingAmountChangeButtons
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height) // Ensure it fills the space
                    
                    
                    
                    //let x = geometry.frame(in: .global).origin.x
                    let y = geometry.frame(in: .global).origin.y
                    let arcCenter = CGPoint(x: geometry.frame(in: .local).midX, y: y)
                    
                    let tieArcRadius = CGFloat(height * 5/6)
                    
                    // For player 1
                    TieAreaView(
                        forPlayer: 1,
                        center: arcCenter,
                        radius: tieArcRadius,
                        startAngle: .degrees(30),
                        endAngle: .degrees(55)
//                        amount: betsOnTie[0]
                    )
                    .onTapGesture {
                        isAnyStackOpen.toggle()
                        gameView.stackTapped(playerIndex: 1, bettingStack: betStacks.tie)
                    }
                    
                    // For player 2
                    TieAreaView(
                        forPlayer: 2,
                        center: arcCenter,
                        radius: tieArcRadius,
                        startAngle: .degrees(60),
                        endAngle: .degrees(85)
//                        amount: betsOnTie[1]
                    )
                    .onTapGesture {
                        isAnyStackOpen.toggle()
                        gameView.stackTapped(playerIndex: 2, bettingStack: betStacks.tie)
                    }
                    
                    
                    // For player 3
                    TieAreaView(
                        forPlayer: 3,
                        center: arcCenter,
                        radius: tieArcRadius,
                        startAngle: .degrees(95),
                        endAngle: .degrees(120)
//                        amount: betsOnTie[2]
                    )
                    .onTapGesture {
                        isAnyStackOpen.toggle()
                        gameView.stackTapped(playerIndex: 3, bettingStack: betStacks.tie)
                    }
                    
                    
                    // For player 4
                    TieAreaView(
                        forPlayer: 4,
                        center: arcCenter,
                        radius: tieArcRadius,
                        startAngle: .degrees(125),
                        endAngle: .degrees(150)
//                        amount: betsOnTie[3]
                    )
                    .onTapGesture {
                        isAnyStackOpen.toggle()
                        gameView.stackTapped(playerIndex: 4, bettingStack: betStacks.tie)
                    }
                    
                    // Banker betting area
                    let bankerArcRadius = CGFloat(height * 11/12)
                    //for Player 1
                    BankerAreaView(forPlayer: 1, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(30), endAngle: .degrees(55))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
                            gameView.stackTapped(playerIndex: 1, bettingStack: betStacks.banker)
                        }
                    
                    //for Player 2
                    BankerAreaView(forPlayer: 2, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(60), endAngle: .degrees(85))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
                            gameView.stackTapped(playerIndex: 2, bettingStack: betStacks.banker)
                        }
                    
                    //for Player 3
                    BankerAreaView(forPlayer: 3, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(95), endAngle: .degrees(120))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
                            gameView.stackTapped(playerIndex: 3, bettingStack: betStacks.banker)
                        }
                    
                    //for Player 4
                    BankerAreaView(forPlayer: 4, center: arcCenter, radius: bankerArcRadius, startAngle: .degrees(125), endAngle: .degrees(150))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
                            gameView.stackTapped(playerIndex: 4, bettingStack: betStacks.banker)
                        }
                    
                    //Player betting are
                    let playerArcRadius = CGFloat(height)
                    //for Player 1
                    PlayerAreaView(forPlayer: 1, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(30), endAngle: .degrees(55))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
//                            print("Checking stack open state \(isAnyStackOpen)");
                            gameView.stackTapped(playerIndex: 1, bettingStack: betStacks.player)
                        }
                    
                    //for Player 2
                    PlayerAreaView(forPlayer: 2, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(60), endAngle: .degrees(85))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
//                            print("Checking stack open state \(isAnyStackOpen)");
                            gameView.stackTapped(playerIndex: 2, bettingStack: betStacks.player)
                        }
                    
                    //for Player 3
                    PlayerAreaView(forPlayer: 3, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(95), endAngle: .degrees(120))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
//                            print("Checking stack open state \(isAnyStackOpen)");
                            gameView.stackTapped(playerIndex: 3, bettingStack: betStacks.player)
                        }
                    
                    //for Player 4
                    PlayerAreaView(forPlayer: 4, center: arcCenter, radius: playerArcRadius, startAngle: .degrees(125), endAngle: .degrees(150))
                        .onTapGesture {
                            isAnyStackOpen.toggle()
//                            print("Checking stack open state \(isAnyStackOpen)");
                            gameView.stackTapped(playerIndex: 4, bettingStack: betStacks.player)
                        }
                    
                }
                .frame(width: width, height: height)
                .padding(12)
                
            }
        }
        
    }
    
    
    var BettingAmountChangeButtons: some View {
        HStack {
            // Positive Betting Buttons
            VStack(spacing: 2) {
                ForEach([5, 20, 100, 1000], id: \.self) { amount in
                    BettingButton(
                        title: "+\(amount)$",
                        amount: amount,
                        isEnabled: isAnyStackOpen
                    ) {
                        gameView.changeBettingAmount(amount)
                        updateBettingAmount()
                    }
                }
                Spacer()
            }
            
            Spacer()
            
            // Negative Betting Buttons
            VStack(spacing: 2) {
                ForEach([-5, -20, -100, -1000], id: \.self) { amount in
                    BettingButton(
                        title: "\(amount)$",
                        amount: amount,
                        isEnabled: isAnyStackOpen
                    ) {
                        gameView.changeBettingAmount(amount)
                        updateBettingAmount()
                    }
                }
                Spacer()
            }
        }
        .padding(8)
    }
    
    
    func findOffsetToShoe() {
        cardsOffset[0] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[0])
        cardsOffset[1] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[1])
        cardsOffset[2] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[2])
        cardsOffset[3] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[3])
        cardsOffset[4] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[4])
        cardsOffset[5] = sizeBetweenPoints(from: BaccaratViewModel.shoeStackPosition, to: BaccaratViewModel.cardsPosition[5])
        
    }
    func sizeBetweenPoints(from start: CGPoint, to end: CGPoint) -> CGSize {
        let width = -end.x + start.x;
        let height = end.y - start.y;
        return CGSize(width: width, height: height)
    }
    
    
    func animateCardsToHands() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                cardsOffset[0] = CGSize(width: 0, height: 0);
            }
            animationDurationOffset += 0.4
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            animationDurationOffset += 0.4
            withAnimation {
                cardsOffset[1] = CGSize(width: 0, height: 0);
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            animationDurationOffset += 0.4
            withAnimation {
                cardsOffset[3] = CGSize(width: 0, height: 0);
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            animationDurationOffset += 0.4
            withAnimation {
                cardsOffset[4] = CGSize(width: 0, height: 0);
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                gameView.playerCard1.cardState = CardsStates.faceUp
                gameView.playerCard2.cardState = CardsStates.faceUp
                gameView.bankerCard1.cardState = CardsStates.faceUp
                gameView.bankerCard2.cardState = CardsStates.faceUp
            }
        }
        
        if gameView.playerCard3.cardValue != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                animationDurationOffset += 0.4
                withAnimation {
                    cardsOffset[2] = CGSize(width: 0, height: 0);
                }
            }
        }
        
        if gameView.bankerCard3.cardValue != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                animationDurationOffset += 0.4
                withAnimation {
                    cardsOffset[5] = CGSize(width: 0, height: 0);
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                gameView.playerCard3.cardState = CardsStates.faceUp
                gameView.bankerCard3.cardState = CardsStates.faceUp
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            
            isShowingResult = true
        }
    }
    
    
    func animateCardsToDiscardPile() {
        cardsOffset[0] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[0])
        cardsOffset[1] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[1])
        cardsOffset[2] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[2])
        cardsOffset[3] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[3])
        cardsOffset[4] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[4])
        cardsOffset[5] = sizeBetweenPoints(from: BaccaratViewModel.discardPilePosition, to: BaccaratViewModel.cardsPosition[5])
    }
    
    ///func updateBettingAmount updates the betting amount to show
    func updateBettingAmount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            withAnimation(.linear) {
                bettingAmount = gameView.getBettingAmount()
            }
        }
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
                            BaccaratViewModel.discardPilePosition = CGPoint(x: (box.frame(in: .global ).minX), y: box.frame(in: .global).minY)
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
                            BaccaratViewModel.shoeStackPosition = CGPoint(x: (box.frame(in: .global).minX), y: box.frame(in: .global).minY)
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
            .padding(.leading, 24)
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
//    let amount: Int64
    
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
        .shadow(radius: 16)
//        ZStack {
//            Text("$\(amount)")
//                .font(.headline)
//                .position(calculateTextPosition(
//                    center: center,
//                    radius: radius,
//                    startAngle: startAngle.degrees,
//                    endAngle: endAngle.degrees)
//                )
//        }
    }
//    func calculateTextPosition(center: CGPoint, radius: CGFloat, startAngle: Double, endAngle: Double) -> CGPoint {
//        let midAngle = (startAngle + endAngle) / 2
//        let radians = midAngle + .pi / 180
//        let x = center.x + radius * cos(radians)
//        let y = center.y - radius * sin(radians)
//        return CGPoint(x: x, y: y)
//    }
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
        .shadow(radius: 16)
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
        .shadow(radius: 16)

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
    }

}



extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}



//custom button for betting buttons
struct BettingButton: View {
    let title: String
    let amount: Int
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("BettingButtonfont", size: 12))
                .foregroundColor(.white)
                .padding()
                .frame(width: 72, height: 28)
                .background(isEnabled ? (amount > 0 ? Color.green : Color.red) : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.6)
    }
}




//struct CustomButtonStyle: ButtonStyle {
//    let isDisabled: Bool
//    
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .frame(width: 72, height: 32)
//            .background(isDisabled ? Color.gray: Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .shadow(color: .black.opacity(0.4), radius: 6, x: 3, y: 3)
//            .scaleEffect(configuration.isPressed ? 0.90: 1.0)
//            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
//    }
//}
