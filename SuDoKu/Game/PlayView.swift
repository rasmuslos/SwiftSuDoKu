//
//  PlayView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 17.02.24.
//

import SwiftUI
import Defaults

struct PlayView: View {
    @Default(.size) private var size
    @Default(.difficulty) private var difficulty
    
    @State var state: GameState = .loading
    
    var body: some View {
        NavigationStack {
            Group {
                switch state {
                    case .loading:
                        ProgressView()
                            .task {
                                state = .ongoing(game: Game.create(size: size, difficulty: difficulty))
                            }
                    case .ongoing(let game):
                        GameView(game: game) {
                            Task {
                                try? await Task.sleep(nanoseconds: 500_000_000)
                                state = .finished(valid: game.board.valid, maxCombo: game.maxCombo)
                            }
                        }
                        .modifier(DebugCompleteModifier(state: $state))
                    case .finished(let valid, let maxCombo):
                        if valid {
                            SolvedView(maxCombo: maxCombo) { state = .loading }
                        } else {
                            FailedView() { state = .loading }
                        }
                }
            }
            .modifier(ToolbarModifier() { state = .loading })
            .modifier(StatisticsModifier())
        }
        .onChange(of: difficulty) { state = .loading }
    }
}

extension PlayView {
    struct ToolbarModifier: ViewModifier {
        @Default(.difficulty) private var difficulty
        
        let createGameCallback: () -> Void
        
        func body(content: Content) -> some View {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            createGameCallback()
                        } label: {
                            Label("retry", systemImage: "arrow.2.squarepath")
                                .labelStyle(.iconOnly)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(Board.Difficulty.allCases, id: \.hashValue) { difficulty in
                                Button {
                                    self.difficulty = difficulty
                                } label: {
                                    Text(difficulty.name)
                                }
                            }
                        } label: {
                            Label("difficulty", systemImage: difficulty.icon)
                                .labelStyle(.iconOnly)
                        }
                    }
                }
        }
    }
}

extension PlayView {
    enum GameState {
        case loading
        case ongoing(game: Game)
        case finished(valid: Bool, maxCombo: Int)
    }
}

extension Board.Difficulty {
    var icon: String {
        switch self {
            case .easy:
                "dial.low.fill"
            case .medium:
                "dial.medium.fill"
            case .hard:
                "dial.high.fill"
            case .extreme:
                "medal.star.fill"
        }
    }
}

extension PlayView {
    struct DebugCompleteModifier: ViewModifier {
        @Default(.size) private var size
        
        @Default(.clues) private var clues
        @Default(.attempts) private var attempts
        
        @Default(.easySolved) private var easySolved
        @Default(.mediumSolved) private var mediumSolved
        @Default(.hardSolved) private var hardSolved
        @Default(.extremeSolved) private var extremeSolved
        
        @Default(.correct) private var correct
        @Default(.mistakes) private var mistakes
        
        @Binding var state: GameState
        
        func body(content: Content) -> some View {
            content
                #if DEBUG && true
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            let game = Game.init(board: .generate(size: size))
                            game.board.values[0] = nil
                            
                            state = .ongoing(game: game)
                            
                            clues = 42
                            attempts = 67
                            
                            easySolved = 12
                            mediumSolved = 17
                            hardSolved = 30
                            extremeSolved = 8
                            
                            correct = 1234
                            mistakes = 56
                        } label: {
                            Image(systemName: "bolt.fill")
                        }
                    }
                }
                #endif
        }
    }
}

#Preview {
    PlayView()
}
