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

