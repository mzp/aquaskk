//
//  MockSelectorBuddy.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/29.
//

import AquaSKKEngine
import Foundation

public class MockSelectorBuddyImpl: SKKSelectorBuddyProtocol {
    let entry: SKKEntry
    public var current: String

    public init(entry: String, okuri: String) {
        self.entry = SKKEntry(std.string(entry), std.string(okuri))
        current = ""
    }

    public func bridgeSelectorQueryEntry() -> [String] {
        return [String(entry.EntryString()), String(entry.OkuriString())]
    }

    public func bridgeSelectorUpdate(candidate: String) {
        current = candidate
    }
}
