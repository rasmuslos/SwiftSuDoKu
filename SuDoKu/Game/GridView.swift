//
//  GridView.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import SwiftUI

struct GridView: View {
    let game: Game
    
    @Binding var selectedSpace: Int?
    @Binding var animation: GameView.GameAnimation
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let size = width / CGFloat(game.board.length)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.background.secondary)
                
                SelectBackground(game: game, size: size, selectedSpace: $selectedSpace)
                Divider(game: game, width: width)
                Grid(game: game, size: size, selectedSpace: $selectedSpace, animation: $animation)
            }
            .border(.accent, width: 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

extension GridView {
    struct Grid: View {
        @Default(.allowMistakes) private var allowMistakes
        
        let game: Game
        let size: CGFloat
        
        @Binding var selectedSpace: Int?
        @Binding var animation: GameView.GameAnimation
        
        var body: some View {
            VStack(spacing: 0) {
                ForEach(0..<game.board.length, id: \.hashValue) { i in
                    HStack(spacing: 0) {
                        ForEach(0..<game.board.length, id: \.hashValue) { j in
                            let index = i * game.board.length + j
                            let animate: Bool = {
                                if animation == .all {
                                    return true
                                } else if case let .row(row) = animation {
                                    return index / game.board.length == row
                                } else if case let .column(column) = animation {
                                    return index % game.board.length == column
                                } else if case let .square(x, y) = animation {
                                    let currentSquareX = (index % game.board.length) / game.board.side
                                    let currentSquareY = (index / game.board.length) / game.board.side
                                    
                                    return currentSquareX == x && currentSquareY == y
                                }
                                
                                return false
                            }()
                            
                            Button {
                                if game.board.values[index] == nil || allowMistakes {
                                    withAnimation(.spring) {
                                        if selectedSpace == index {
                                            selectedSpace = nil
                                        } else {
                                            selectedSpace = index
                                        }
                                    }
                                }
                            } label: {
                                if let number = game.board.values[index] {
                                    Text(String(number))
                                        .font(.title3)
                                        .fontDesign(.rounded)
                                        .scaleEffect(animate ? 1.5 : 1)
                                        .animation(
                                            .spring(
                                                response: 0.2,
                                                dampingFraction: 0.2,
                                                blendDuration: 0.2)
                                            .delay(
                                                (Double(index) / Double(game.board.length * game.board.length)) * 0.5),
                                            value: animate)
                                } else if selectedSpace == index {
                                    Rectangle()
                                        .foregroundStyle(.gray.opacity(0.5))
                                } else {
                                    Color.clear
                                }
                            }
                            .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
    }
}
