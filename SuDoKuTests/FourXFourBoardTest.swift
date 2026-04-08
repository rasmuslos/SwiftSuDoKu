//
//  FourXFourBoardTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Testing
import SuDoKu

@Suite("4x4 Board tests")
struct FourXFourBoardTests {
    // MARK: Generation
    
    @Test
    func test4x4BoardValidity() {
        for _ in 1...250 {
            let board = Board.generate(size: .FourXFour)
            #expect(board.valid)
        }
    }
    
    @Test
    func test4x4BoardGenerationSpeed() {
        // Performance smoke test
        _ = Board.generate(size: .FourXFour)
    }
    
    // MARK: Validity
    
    @Test
    func testInvalid4x4Row() {
        let board = Board(size: .FourXFour, values: .init(repeating: 1, count: 16))
        #expect(board.valid == false)
    }
    
    @Test
    func testInvalid4x4Column() {
        let board = Board(size: .FourXFour, values: [
            1, 2, 3, 4,
            1, 2, 3, 4,
            1, 2, 3, 4,
            1, 2, 3, 4,
        ])
        
        #expect(board.valid == false)
    }
    
    @Test
    func testInvalid4x4Square() {
        let board = Board(size: .FourXFour, values: [
            1, 2, 3, 4,
            2, 3, 4, 1,
            3, 4, 1, 2,
            4, 1, 2, 3,
        ])
        
        #expect(board.valid == false)
    }
    
    // MARK: Solving
    
    @Test
    func test4x4Solvable() {
        let board = Board(size: .FourXFour, values: [
            1, nil, 3,   4,
            3, nil, 1,   2,
            2, 3  , nil, 1,
            4, nil, 2,   3,
        ])
        
        #expect(board.solvable())
    }
    
    // MARK: Obfuscating
    
    @Test
    func test4x4Obfuscate() {
        for _ in 1...25 {
            let board = Board.generate(size: .FourXFour)
            board.obfuscate(difficulty: .allCases.randomElement()!)
            
            #expect(board.solvable())
        }
    }
    
    @Test
    func test4x4ObfuscateSpeed() {
        // Performance smoke test
        let board = Board.generate(size: .FourXFour)
        board.obfuscate(difficulty: .extreme)
    }
    
    // MARK: Suggestions
    
    @Test
    func test4x4Suggestions() {
        let board = Board(size: .FourXFour, values: [
            1,   nil, 2,   nil,
            nil, nil, 3,   nil,
            2,   3,   4,   1,
            nil, nil, nil, nil,
        ])
        
        #expect(board.suggestions(index: 1, strength: .none) == [])
        
        #expect(board.suggestions(index: 1, strength: .square) == [2, 3, 4])
        #expect(board.suggestions(index: 7, strength: .square) == [1, 4])
        #expect(board.suggestions(index: 15, strength: .square) == [2, 3])
        
        #expect(board.suggestions(index: 1, strength: .full) == [4])
        #expect(board.suggestions(index: 7, strength: .full) == [4])
        #expect(board.suggestions(index: 15, strength: .full) == [2, 3])
    }
}
