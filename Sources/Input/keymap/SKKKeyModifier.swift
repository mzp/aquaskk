//
//  SKKKeyModifier.swift
//  AquaSKK
//
//  Created by mzp on 2025/05/12.
//

public struct SKKKeyModifier: OptionSet, Hashable, Equatable, Sendable {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static public let none = SKKKeyModifier([])
    static public let shift = SKKKeyModifier(rawValue: 1 << 1)
    static public let control = SKKKeyModifier(rawValue: 1 << 2)
    static public let option = SKKKeyModifier(rawValue: 1 << 3)
    static public let command = SKKKeyModifier(rawValue: 1 << 4)
}
