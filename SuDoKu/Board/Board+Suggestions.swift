//
//  Board+Suggestions.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 16.02.24.
//

import Foundation
import SwiftUI

public extension Board {
    func suggestions(index: Int, strength: SuggestionStrength) -> [Int] {
        if strength == .none {
            return []
        }
        
        // So there are good ways to do this, but this one is also very much a implementation
        let row = Int((Float(index) / Float(length)).rounded(.towardZero))
        let column = index % length
        let squareX = column / side
        let squareY = row / side
        
        var seen = Set<Int>()
        
        if strength == .full {
            for i in 0..<length {
                // Row
                if let value = values[row * length + i] {
                    seen.insert(value)
                }
                
                // Column
                if let value = values[i * length + column] {
                    seen.insert(value)
                }
            }
        }
        
        // Square
        let squareOffset = squareX * side + squareY * side * length
        for j in 0..<side {
            for k in 0..<side {
                if let value = values[squareOffset + j + k * length] {
                    seen.insert(value)
                }
            }
        }
        
        return (1...length).filter { !seen.contains($0) }
    }
    
    enum SuggestionStrength: Int, CaseIterable, Defaults.Serializable {
        case none = 0
        case square = 1
        case full = 2
    }
}

extension Board.SuggestionStrength {
    var name: LocalizedStringKey {
        switch self {
            case .none:
                "suggestions.none"
            case .square:
                "suggestions.square"
            case .full:
                "suggestions.full"
        }
    }
}
