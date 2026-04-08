//
//  NineXNineBoardTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Testing
import SuDoKu

@Suite("9x9 Board tests")
struct NineXNineBoardTests {
    // MARK: Generation
    
    @Test
    func test9x9BoardValidity() {
        for _ in 1...250 {
            let board = Board.generate(size: .NineXNine)
            #expect(board.valid)
        }
    }
    
    @Test
    func test9x9BoardGenerationSpeed() {
        // Performance smoke test
        _ = Board.generate(size: .NineXNine)
    }
    
    // MARK: Validity
    
    @Test
    func testInvalid9x9Row() {
        let board = Board(size: .NineXNine, values: .init(repeating: 1, count: 81))
        #expect(board.valid == false)
    }
    
    @Test
    func testInvalid9x9Column() {
        let board = Board(size: .NineXNine, values: [
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            1, 2, 3, 4, 5, 6, 7, 8, 9,
        ])
        
        #expect(board.valid == false)
    }
    
    @Test
    func testInvalid9x9Square() {
        let board = Board(size: .NineXNine, values: [
            1, 2, 3, 4, 5, 6, 7, 8, 9,
            2, 3, 4, 5, 6, 7, 8, 9, 1,
            3, 4, 5, 6, 7, 8, 9, 1, 2,
            4, 5, 6, 7, 8, 9, 1, 2, 3,
            5, 6, 7, 8, 9, 1, 2, 3, 4,
            6, 7, 8, 9, 1, 2, 3, 4, 5,
            7, 8, 9, 1, 2, 3, 4, 5, 6,
            8, 9, 1, 2, 3, 4, 5, 6, 7,
            9, 1, 2, 3, 4, 5, 6, 7, 8,
        ])
        
        #expect(board.valid == false)
    }
    
    // MARK: Solving
    
    @Test
    func test9x9Solvable() {
        let board = Board(size: .NineXNine, values: [
            1, 2,   3, 4,   5, 6,   7, 8, 9,
            4, nil, 6, nil, 8, nil, 1, 2, 3,
            7, 8,   9, 1,   2, 3,   4, 5, 6,
            2, 3,   4, 5,   6, 7,   8, 9, 1,
            5, nil, 7, 8,   9, 1,   2, 3, 4,
            8, 9,   1, 2,   3, 4,   5, 6, 7,
            3, 4,   5, 6,   7, 8,   9, 1, 2,
            6, nil, 8, 9,   1, 2,   3, 4, 5,
            9, 1,   2, 3,   4, 5,   6, 7, 8,
        ])
        
        #expect(board.solvable())
    }
    
    @Test
    func test9x9Impossible() {
        let board = Board(size: .NineXNine, values: [
            1,   2, 3, 4, 5, 6, 7,   8, 9,
            nil, 5, 6, 7, 8, 9, 1,   2, 4,
            7,   8, 9, 1, 2, 3, nil, 5, 6,
            2,   3, 4, 5, 6, 7, 8,   9, 1,
            5,   6, 7, 8, 9, 1, 2,   3, nil,
            8,   9, 1, 2, 3, 4, 5,   6, 7,
            3,   4, 5, 6, 7, 8, 9,   1, 2,
            6,   7, 8, 9, 1, 2, 3,   4, 5,
            9,   1, 2, 3, 4, 5, 6,   7, 8,
        ])
        
        #expect(board.solvable() == false)
    }
    
    // MARK: Obfuscating
    
    @Test
    func test9x9Obfuscate() {
        let board = Board.generate(size: .NineXNine)
        board.obfuscate(difficulty: .allCases.randomElement()!)
            
        #expect(board.solvable())
    }
    
    // MARK: Suggestions
    
    @Test
    func test9x9Suggestions() {
        let board = Board(size: .NineXNine, values: [
            1, 2,   3, 4,   5,   6,   7, 8, 9,
            4, nil, 6, nil, 8,   nil, 1, 2, 3,
            7, 8,   9, 1,   2,   3,   4, 5, 6,
            2, 3,   4, 5,   6,   7,   8, 9, 1,
            5, nil, 7, 8,   nil, 1,   2, 3, 4,
            8, 9,   1, 2,   3,   4,   5, 6, 7,
            3, 4,   5, 6,   7,   8,   9, 1, 2,
            6, nil, 8, 9,   1,   2,   3, 4, nil,
            9, 1,   2, 3,   4,   nil, 6, 7, nil,
        ])
        
        #expect(board.suggestions(index: 10, strength: .none) == [])
        
        #expect(board.suggestions(index: 10, strength: .square) == [5])
        #expect(board.suggestions(index: 40, strength: .square) == [9])
        #expect(board.suggestions(index: 80, strength: .square) == [5, 8])
        
        #expect(board.suggestions(index: 10, strength: .full) == [5])
        #expect(board.suggestions(index: 40, strength: .full) == [9])
        #expect(board.suggestions(index: 80, strength: .full) == [5, 8])
    }
}
