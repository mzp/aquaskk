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

    public static let none = SKKKeyModifier([])
    public static let shift = SKKKeyModifier(rawValue: 1 << 1)
    public static let control = SKKKeyModifier(rawValue: 1 << 2)
    public static let option = SKKKeyModifier(rawValue: 1 << 3)
    public static let command = SKKKeyModifier(rawValue: 1 << 4)
}
