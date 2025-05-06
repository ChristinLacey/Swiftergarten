//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Christin Lacey on 5/3/25.
//

import SwiftUI

struct ContentView: View {
    enum Move: String, CaseIterable {
        case rock, paper, scissors
        
        func beats(_ other: Move) -> Bool {
            switch(self, other) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                return true
            default:
                return false
            }
        }
    }
    
    @State var enemyMove = Move.allCases.randomElement()!
    @State var shouldWin = Bool.random()
    @State var currRound = 1
    @State var finalRound = false
    @State var score = 0
    var winningChoice = true
    
    
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .frame(width: 130, alignment: .topTrailing)
            Text("Round \(currRound) of 10")
                .frame(width: 110, height: .infinity, alignment: .topTrailing)
            Spacer()
        
            
            //Text("Your opponent selected \(enemyMove ?? Move.rock)")
            //let choice = Int.random(in:0...2)
            Text("Your opponent selected \(enemyMove.rawValue.capitalized)")
            
            Text("what should you pick in order to \(shouldWin ? "WIN?" : "LOSE?")")
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Button(move.rawValue.capitalized) {
                        makeMove(move)
                    }
                    //.buttonStyle(.borderedProminent)
                }
            } .choiceButtonStyle()
            
                
            
            Spacer()
        }
        .padding()
        
        .alert("Game Over", isPresented: $finalRound) {
            Text("Your score was \(score)")
        }
    }
    
    func makeMove(_ playerMove: Move) {
        let didWin = playerMove.beats(enemyMove)
        let isDraw = playerMove == enemyMove
        
        if shouldWin && didWin {
            score += 1
        } else if !shouldWin && !didWin && !isDraw {
            score += 1
        } else {
            score -= 1
        }
        rematch()
    }
    
    func rematch() {
        shouldWin.toggle()
        currRound += 1
        enemyMove = Move.allCases.randomElement()!
        
        if currRound > 10 {
            finalRound = true
            reset()
        }
    }
    func reset() {
        currRound = 1
        score = 0
        finalRound = false
        shouldWin = Bool.random()
        enemyMove = Move.allCases.randomElement()!
    }
}

#Preview {
    ContentView()
}
