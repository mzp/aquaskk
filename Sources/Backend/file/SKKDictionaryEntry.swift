//
//  SKKDictionaryEntry.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/17/25.
//

import Foundation

public struct SKKDictionaryEntryImpl: Equatable, CustomDebugStringConvertible {
    public var entry: [UInt8]
    public var value: [UInt8]

    public init(entry: [UInt8], value: [UInt8]) {
        self.entry = entry
        self.value = value
    }

    public init(entry: String, value: String) {
        self.entry = Array(entry.utf8)
        self.value = Array(value.utf8)
    }

    // MARK: - Entry

    public func entryString(using encoding: String.Encoding) -> String? {
        String(data: Data(entry), encoding: encoding)
    }

    // MARK: - Value

    public func valueString(using encoding: String.Encoding) -> String? {
        String(data: Data(value), encoding: encoding)
    }

    var valueStdString: std.string {
        get {
            SKKRawString(value)
        } set {
            let array = SKKRawArray(newValue)
            value = Array(array)
        }
    }

    // MARK: -

    func takeBridgeObject() -> SKKDictionaryEntry {
        return .init(
            first: SKKRawString(entry),
            second: SKKRawString(value)
        )
    }

    public var debugDescription: String {
        """
        DictionaryEntry("\(entryString(using: .utf8) ?? "?")", "\(valueString(using: .utf8) ?? "?")")
        """
    }
}
