//
//  SendableEvent.swift
//  TyperTests
//
//  Created by mzp on 8/13/24.
//

import AppKit
import Foundation

struct SendableEvent: Sendable {
    var characters: String
    var charactersIgnoringModifiers: String
    var keyCode: UInt16
    var modifiers: NSEvent.ModifierFlags
    var timestapm: TimeInterval

    var nsEvent: NSEvent {
        return NSEvent.keyEvent(
            with: .keyDown,
            location: NSPoint(x: 0, y: 0),
            modifierFlags: modifiers,
            timestamp: timestapm,
            windowNumber: 0,
            context: nil,
            characters: characters,
            charactersIgnoringModifiers: charactersIgnoringModifiers,
            isARepeat: false,
            keyCode: keyCode
        )!
    }

    init(
        characters: String,
        charactersIgnoringModifiers: String? = nil,
        keyCode: UInt16 = 20,
        modifiers: NSEvent.ModifierFlags = []
    ) {
        self.characters = characters
        self.charactersIgnoringModifiers = charactersIgnoringModifiers ?? characters
        self.keyCode = keyCode
        self.modifiers = modifiers
        timestapm = Date().timeIntervalSince1970
    }
}
