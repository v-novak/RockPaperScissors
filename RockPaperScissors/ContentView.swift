//
//  ContentView.swift
//  RockPaperScissors
//

import SwiftUI

enum Move: Int {
    case rock = 0
    case paper
    case scissors
    
    var description: String {
        switch self {
        case .rock:
            return "🗿"
        case .paper:
            return "📜"
        case .scissors:
            return "✂️"
        }
    }
}

struct MoveView: View {
    var move: Move
    
    var body: some View {
        Text(move.description)
            .font(.system(size: 48))
    }
}

func playerWins(cpuMove: Move, playerMove: Move) -> Bool
{
    let winningMoves: [Move] = [.paper, .scissors, .rock]
    return winningMoves[cpuMove.rawValue] == playerMove
}

func playerLoses(cpuMove: Move, playerMove: Move) -> Bool
{
    let winningMoves: [Move] = [.paper, .scissors, .rock]
    return winningMoves[playerMove.rawValue] == cpuMove
}

struct ContentView: View {
    @State private var cpuChoice: Move = .rock
    @State private var playerShouldWin: Bool = true
    @State private var score = 0
    @State private var attempts = 0
    @State private var lastAnswerCorrect: Bool?
    
    @ViewBuilder var cpuMoveLabel: some View {
        Text("I choose: ")
        MoveView(move: cpuChoice)
        Text("You should: ")
        Text("\(playerShouldWin ? "Win" : "Lose")")
            .foregroundColor(playerShouldWin ? .green : .red)
            .font(.title2)
        
    }

    func toggle() {
        var newCpuChoice = Move(rawValue: Int.random(in: 0...2))!
        var newPlayerShouldWin = Bool.random()
        
        // randomise until something changes
        while newCpuChoice == cpuChoice && newPlayerShouldWin == playerShouldWin {
            newCpuChoice = Move(rawValue: Int.random(in: 0...2))!
            newPlayerShouldWin = Bool.random()
        }
        cpuChoice = newCpuChoice
        playerShouldWin = newPlayerShouldWin
    }
    
    func reset() {
        score = 0
        attempts = 0
        lastAnswerCorrect = nil
    }
    
    func movePressed(_ move: Move) {
        if playerShouldWin && playerWins(cpuMove: cpuChoice, playerMove: move)
            || !playerShouldWin && playerLoses(cpuMove: cpuChoice, playerMove: move)
        {
            score += 1
            lastAnswerCorrect = true
        } else {
            lastAnswerCorrect = false
        }
        attempts += 1
        toggle()
    }
    
    var body: some View {
        VStack {
            Spacer()
            cpuMoveLabel
            Spacer()
            
            Text("What is your move?")
            
            HStack {
                ForEach(0..<3) {
                    moveIndex in
                    Button(Move(rawValue: moveIndex)!.description)
                    {
                        movePressed(Move(rawValue: moveIndex)!)
                    }
                    .font(.system(size: 48))
                    .buttonStyle(.bordered)
                }
            }
            
            ZStack {
                Text("🎉 Correct!")
                    .foregroundColor(.green)
                    .opacity(lastAnswerCorrect ?? false ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.2), value: (attempts > 0))
                    
                Text("🤔 Incorrect")
                    .foregroundColor(.red)
                    .opacity(lastAnswerCorrect ?? true ? 0.0 : 1.0)
                    .animation(.easeOut(duration: 0.2), value: (attempts > 0))
            }
            
            Spacer()
            
        
            Group {
                Text("Your score is \(score) out of \(attempts)")
                Button(action: reset, label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                    Text("Reset progress")
                })
            }
            .opacity(attempts > 0 ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.2), value: (attempts > 0))
            
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
