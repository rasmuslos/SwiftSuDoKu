//
//  GameView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI
import Defaults

struct GameView: View {
    @Default(.allowMistakes) private var allowMistakes
    @Default(.difficulty) private var difficulty
    
    let game: Game
    let completedCallback: () -> Void
    
    @State private var animation: GameAnimation = .none
    
    @State private var shake = false
    @State private var blockUI = false
    @State private var selectedSpace: Int?
    
    private var selectedSpaceProxy: Binding<Int?> {
        .init(get: { selectedSpace }, set: {
            if blockUI { return }
            selectedSpace = $0
        })
    }
    
    var body: some View {
        VStack {
            HStack {
                if !allowMistakes {
                    Text("\(game.correct) correct")
                }
                
                Spacer()
                
                Text(String(String(game.board.solved * 100).prefix(2)))
                + Text(verbatim: "% - ")
                + Text(difficulty.name)
                
                Spacer()
                
                if !allowMistakes {
                    Text("\(game.mistakes) mistakes")
                }
            }
            .font(.caption.smallCaps())
            .foregroundStyle(.secondary)
            
            GridView(game: game, selectedSpace: selectedSpaceProxy, animation: $animation)
                .offset(x: shake ? 30 : 0)
            
            Spacer(minLength: 40)
            
            NumberView(game: game, shake: $shake, selectedSpace: selectedSpaceProxy, animation: $animation)
            
            Spacer()
            
            ClueView(game: game, blockUI: $blockUI, selectedSpace: $selectedSpace)
        }
        .padding()
        .environment(game)
        .navigationTitle("sudoku.title")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: animation)
        .onChange(of: game.board.solved) {
            if game.board.solved >= 1 {
                withAnimation {
                    blockUI = true
                    animation = .all
                } completion: {
                    animation = .none
                    completedCallback()
                }
            }
        }
    }
}

extension GameView {
    enum GameAnimation: Equatable {
        case none
        case all
        case row(row: Int)
        case column(column: Int)
        case square(x: Int, y: Int)
    }
}

#Preview {
    NavigationStack {
        GameView(game: .create(size: .NineXNine, difficulty: .medium)) {
            print("Completed")
        }
    }
}

#Preview {
    NavigationStack {
        GameView(game: .create(size: .FourXFour, difficulty: .medium)) {
            print("Completed")
        }
    }
}
