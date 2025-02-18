//
//  SKKDictionaryEntry.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/17/25.
//

import Foundation

struct SKKDictionaryEntryImpl: Equatable, CustomDebugStringConvertible {
    var entry: [UInt8]
    var value: [UInt8]

    func entryString(using encoding: String.Encoding) -> String? {
        String(data: Data(entry), encoding: encoding)
    }
    func valueString(using encoding: String.Encoding) -> String? {
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

    init(entry: [UInt8], value: [UInt8]) {
        self.entry = entry
        self.value = value
    }

    init(entry: String, value: String) {
        self.entry = Array(entry.utf8)
        self.value = Array(value.utf8)
    }

    func takeBridgeObject() -> SKKDictionaryEntry {
        return .init(
            first: SKKRawString(entry),
            second: SKKRawString(value)
        )
    }

    var debugDescription: String {
        """
        DictionaryEntry("\(entryString(using: .utf8) ?? "?")", "\(valueString(using: .utf8) ?? "?")")
        """
    }
}
