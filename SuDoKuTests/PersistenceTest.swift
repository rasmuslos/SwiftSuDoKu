//
//  PersistenceTest.swift
//  SuDoKuTests
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Testing
import SuDoKu
import Defaults

@Suite("Persistence tests")
struct PersistenceTests {
    @Test
    func testAttemptCounter() {
        let currentCount = Defaults[.attempts]
        let game = Game.create(size: .NineXNine, difficulty: .easy)
        _ = game.input(number: 1, index: 0)
        
        #expect(Defaults[.attempts] == currentCount + 1)
    }
}
