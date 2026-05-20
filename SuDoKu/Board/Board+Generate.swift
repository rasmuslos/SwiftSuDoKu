//
//  Board+Generate.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation
import SwiftUI

public extension Board {
    static func generate(size: Size) -> Self {
        let length = size.rawValue
        
        let numbers = Array(1...length)
        let side = Int(sqrt(Double(length)))
        var board = [Int]()
        
        // Generate a valid but simple starting point
        for row in 0..<length {
            let offset = row * side + Int(Float(row / side).rounded(.towardZero))
            var tmp = numbers
            
            for _ in 0..<offset {
                tmp.append(tmp.removeFirst())
            }
            
            board.append(contentsOf: tmp)
        }
        
        // Swap random numbers (3x)
        for _ in 1...3 {
            for number in 1..<numbers.count {
                let replacement = numbers.randomElement()!
                
                board.replace([replacement], with: [-1])
                board.replace([number], with: [replacement])
                board.replace([-1], with: [number])
            }
        }
        
        // Shuffle rows inside a square
        for group in 0..<length / side {
            // first index: offset, second row: offset + length, etc.
            let offset = (group * side) * length
            
            // Shuffle 7 times
            for _ in 1...7 {
                let target = Int.random(in: 1...side) - 1
                let replacement = Int.random(in: 1...side) - 1
                
                if target == replacement {
                    continue
                }
                
                let targetOffset = offset + length * target
                let replacementOffset = offset + length * replacement
                
                for i in 0..<length {
                    board.swapAt(targetOffset + i, replacementOffset + i)
                }
            }
        }
        
        // Shuffle columns inside a square
        for group in 0..<length / side {
            let offset = group * side
            
            for _ in 1...7 {
                let target = Int.random(in: 1...side) - 1
                let replacement = Int.random(in: 1...side) - 1
                
                if target == replacement {
                    continue
                }
                
                let targetOffset = offset + target
                let replacementOffset = offset + replacement
                
                for i in 0..<length {
                    board.swapAt(targetOffset + length * i, replacementOffset + length * i)
                }
            }
        }
        
        // Shuffle square rows (3x)
        for _ in 1...3 {
            let offset = Int.random(in: 0...(length / side) - 1) * (length * side)
            let count = side * length
            
            for _ in 0..<count {
                board.append(board.remove(at: offset))
            }
        }
        
        // Shuffle square columns (3x)
        // i am so tired of doing this, fuck you
        
        return .init(size: size, values: board)
    }
    
    enum Size: Int, Defaults.Serializable, CaseIterable {
        case FourXFour = 4
        case NineXNine = 9
    }
}

public extension Board {
    func obfuscate(difficulty: Difficulty) {
        var allowedIndexes = Array(0..<length * length)
        
        repeat {
            let index = allowedIndexes.randomElement()!
            
            let board = copy
            
            board.values[index] = nil
            
            if board.solvable() {
                values[index] = nil
            }
            
            allowedIndexes.removeAll(where: { $0 == index })
        } while solved > difficulty.rawValue && !allowedIndexes.isEmpty
    }
    
    enum Difficulty: Float, Defaults.Serializable, CaseIterable {
        case easy = 0.6
        case medium = 0.5
        case hard = 0.4
        case extreme = 0.3
    }
}

extension Board.Difficulty {
    var name: LocalizedStringKey {
        switch self {
            case .easy:
                return "difficulty.easy"
            case .medium:
                return "difficulty.medium"
            case .hard:
                return "difficulty.hard"
            case .extreme:
                return "difficulty.extreme"
        }
    }
}
