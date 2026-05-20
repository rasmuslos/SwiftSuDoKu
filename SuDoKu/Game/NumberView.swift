//
//  NumberView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI

struct NumberView: View {
    @Default(.suggestionStrength) var suggestionStrength
    
    let game: Game
    
    @Binding var shake: Bool
    @Binding var selectedSpace: Int?
    @Binding var animation: GameView.GameAnimation
    
    var suggestions: [Int] {
        guard let selectedSpace = selectedSpace else { return [] }
        return game.board.suggestions(index: selectedSpace, strength: suggestionStrength)
    }
    
    var body: some View {
        let disabled = selectedSpace == nil
        
        LazyVGrid(columns: .init(repeating: .init(.flexible()), count: game.board.length)) {
            ForEach(1...game.board.length, id: \.hashValue) { number in
                let suggested = suggestions.contains(number)
                
                Button {
                    let result = game.input(number: number, index: selectedSpace!)
                    
                    if !result.success {
                        shake = true
                        
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                            shake = false
                        }
                    } else {
                        withAnimation(.spring) {
                            selectedSpace = nil
                            animation = result.animation
                        } completion: {
                            animation = .none
                        }
                    }
                } label: {
                    Text(String(number))
                        .font(.title)
                        .fontDesign(.rounded)
                        .foregroundStyle(disabled ? .gray.opacity(0.75) : suggested ? .accent : .primary)
                }
            }
        }
        .disabled(disabled)
    }
}
