//
//  GameTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Testing
import SuDoKu
import Defaults

@Suite("Game tests")
struct GameTests {
    @Test
    func testValidInput() {
        let game = Game(board: .init(size: .FourXFour, values: [
            nil, 2, 3, 4,
            3, 4, 1, 2,
            2, 3, 4, 1,
            4, 1, 2, 3,
        ]))
        
        #expect(game.input(number: 1, index: 0).success)
        #expect(game.board.solved == 1)
    }
    
    @Test
    func testInvalidInput() {
        withAllowMistakes(false) {
            let game = Game(board: .init(size: .FourXFour, values: [
                nil, 2, 3, 4,
                3, 4, 1, 2,
                2, 3, 4, 1,
                4, 1, 2, 3,
            ]))
            
            #expect(!game.input(number: 2, index: 0).success)
            #expect(game.board.solved != 1)
        }
    }
    
    @Test
    func testComboIncrementsOnCorrectInputs() {
        let game = Game(board: .init(size: .FourXFour, values: [
            nil, nil, 3, 4,
            3, 4, 1, 2,
            2, 3, 4, 1,
            4, 1, 2, 3,
        ]))
        
        #expect(game.combo == 0)
        #expect(game.input(number: 1, index: 0).success)
        #expect(game.combo == 1)
        #expect(game.input(number: 2, index: 1).success)
        #expect(game.combo == 2)
        #expect(game.maxCombo == 2)
    }
    
    @Test
    func testComboResetsOnMistake() {
        withAllowMistakes(false) {
            let game = Game(board: .init(size: .FourXFour, values: [
                nil, nil, 3, 4,
                3, 4, 1, 2,
                2, 3, 4, 1,
                4, 1, 2, 3,
            ]))
            
            #expect(game.input(number: 1, index: 0).success)
            #expect(game.combo == 1)
            #expect(!game.input(number: 3, index: 1).success)
            #expect(game.combo == 0)
            #expect(game.maxCombo == 1)
        }
    }
    
    @Test
    func testMaxComboPreservedAfterReset() {
        withAllowMistakes(false) {
            let game = Game(board: .init(size: .FourXFour, values: [
                nil, nil, nil, 4,
                3, 4, 1, 2,
                2, 3, 4, 1,
                4, 1, 2, 3,
            ]))
            
            #expect(game.input(number: 1, index: 0).success)
            #expect(game.input(number: 2, index: 1).success)
            #expect(game.combo == 2)
            #expect(!game.input(number: 4, index: 2).success)
            #expect(game.combo == 0)
            #expect(game.maxCombo == 2)
        }
    }
    
    @Test
    func testInvalidAllowedInput() {
        withAllowMistakes(true) {
            let game = Game(board: .init(size: .FourXFour, values: [
                nil, 2, 3, 4,
                3, 4, 1, 2,
                2, 3, 4, 1,
                4, 1, 2, 3,
            ]))
            
            #expect(game.input(number: 2, index: 0).success)
            #expect(game.board.solved == 1)
        }
    }
}
private func withAllowMistakes(_ value: Bool, _ body: () -> Void) {
    let old = Defaults[.allowMistakes]
    Defaults[.allowMistakes] = value
    defer { Defaults[.allowMistakes] = old }
    body()
}

