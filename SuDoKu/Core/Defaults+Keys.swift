//
//  Persistence.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation

public extension Defaults.Keys {
    // MARK: Settings
    
    static let allowMistakes = Key<Bool>("allowMistakes", default: false)
    static let suggestionStrength = Key<Board.SuggestionStrength>("suggestionStrength", default: .none)
    
    // MARK: Options
    
    static let size = Key<Board.Size>("size", default: .NineXNine)
    static let difficulty = Key<Board.Difficulty>("difficulty", default: .easy)
    
    static let setupComplete = Key<Bool>("setupComplete", default: false)

    // MARK: Statistics

    static let clues = Key<Int>("clues", default: 0)
    static let attempts = Key<Int>("attempts", default: 0)

    static let correct = Key<Int>("correct", default: 0)
    static let mistakes = Key<Int>("mistakes", default: 0)
    static let maxCombo = Key<Int>("maxCombo", default: 0)

    static let easySolved = Key<Int>("easySolved", default: 0)
    static let mediumSolved = Key<Int>("mediumSolved", default: 0)
    static let hardSolved = Key<Int>("hardSolved", default: 0)
    static let extremeSolved = Key<Int>("extremeSolved", default: 0)
}
