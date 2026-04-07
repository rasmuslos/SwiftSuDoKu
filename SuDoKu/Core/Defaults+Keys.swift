//
//  Persistence.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 15.02.24.
//

import Foundation
import Defaults

public extension Defaults.Keys {
    // MARK: Settings
    
    static let allowMistakes = Key<Bool>("allowMistakes", default: false)
    static let suggestionStrength = Key<Board.SuggestionStrength>("suggestionStrength", default: .none)
    
    // MARK: Options
    
    static let size = Key<Board.Size>("size", default: .NineXNine)
    static let difficulty = Key<Board.Difficulty>("difficulty", default: .easy)
    
    static let setupComplete = Key("setupComplete", default: false)
    
    // MARK: Statistics
    
    static let clues = Key("clues", default: 0)
    static let attempts = Key("attempts", default: 0)
    
    static let correct = Key("correct", default: 0)
    static let mistakes = Key("mistakes", default: 0)
    
    static let easySolved = Key("easySolved", default: 0)
    static let mediumSolved = Key("mediumSolved", default: 0)
    static let hardSolved = Key("hardSolved", default: 0)
    static let extremeSolved = Key("extremeSolved", default: 0)
}
