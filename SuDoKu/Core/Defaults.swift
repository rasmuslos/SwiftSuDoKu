//
//  Defaults.swift
//  SuDoKu
//
//  Created by Rasmus Krämer on 20.05.26.
//

import Foundation
import SwiftUI
import Observation

public enum Defaults {
    fileprivate nonisolated(unsafe) static let store: UserDefaults = .standard

    public static subscript<Value: Serializable>(key: Key<Value>) -> Value {
        get {
            guard let raw = store.object(forKey: key.name),
                  let value = Value(defaultsRawValue: raw) else {
                return key.defaultValue
            }
            return value
        }
        set {
            store.set(newValue.defaultsRawValue, forKey: key.name)
            Tracker.bump()
        }
    }

    public static func reset<Value>(_ key: Key<Value>) {
        store.removeObject(forKey: key.name)
        Tracker.bump()
    }

    public class Keys: @unchecked Sendable {
        public typealias Key = Defaults.Key
        fileprivate init() {}
    }

    public final class Key<Value: Serializable>: Keys, @unchecked Sendable {
        public let name: String
        public let defaultValue: Value

        public init(_ name: String, default defaultValue: Value) {
            self.name = name
            self.defaultValue = defaultValue
            super.init()
        }
    }

    public protocol Serializable: Sendable {
        init?(defaultsRawValue: Any)
        var defaultsRawValue: Any { get }
    }
}

// MARK: - Built-in conformances

extension Bool: Defaults.Serializable {
    public init?(defaultsRawValue raw: Any) {
        guard let value = raw as? Bool else { return nil }
        self = value
    }
    public var defaultsRawValue: Any { self }
}

extension Int: Defaults.Serializable {
    public init?(defaultsRawValue raw: Any) {
        guard let value = raw as? Int else { return nil }
        self = value
    }
    public var defaultsRawValue: Any { self }
}

extension Float: Defaults.Serializable {
    public init?(defaultsRawValue raw: Any) {
        if let value = raw as? Float { self = value }
        else if let value = raw as? Double { self = Float(value) }
        else if let value = raw as? NSNumber { self = value.floatValue }
        else { return nil }
    }
    public var defaultsRawValue: Any { self }
}

public extension Defaults.Serializable where Self: RawRepresentable, RawValue: Defaults.Serializable {
    init?(defaultsRawValue raw: Any) {
        guard let raw = RawValue(defaultsRawValue: raw) else { return nil }
        self.init(rawValue: raw)
    }
    var defaultsRawValue: Any { rawValue.defaultsRawValue }
}

// MARK: - SwiftUI bridge

@MainActor
@Observable
fileprivate final class Tracker {
    static let shared = Tracker()

    var revision: UInt64 = 0

    nonisolated static func bump() {
        Task { @MainActor in
            shared.revision &+= 1
        }
    }
}

@propertyWrapper
@MainActor
public struct Default<Value: Defaults.Serializable>: DynamicProperty {
    public let key: Defaults.Key<Value>

    public init(_ key: Defaults.Key<Value>) {
        self.key = key
    }

    public var wrappedValue: Value {
        get {
            _ = Tracker.shared.revision
            return Defaults[key]
        }
        nonmutating set { Defaults[key] = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }

    public func reset() {
        Defaults.reset(key)
    }
}
