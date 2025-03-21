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

extension SendableEvent {
    static let skkEnter = SendableEvent(characters: "m", modifiers: .control)
    static let skkJmode = SendableEvent(characters: "j", modifiers: .control)
    static let skkCancel = SendableEvent(characters: "g", modifiers: .control)
    static let skkBackspace = SendableEvent(characters: "h", modifiers: .control)
    static let skkDelete = SendableEvent(characters: "d", modifiers: .control)
    static let skkLeft = SendableEvent(characters: "b", modifiers: .control)
    static let skkRight = SendableEvent(characters: "f", modifiers: .control)
    static let skkUp = SendableEvent(characters: "a", modifiers: .control)
    static let skkDown = SendableEvent(characters: "e", modifiers: .control)
    static let skkTab = SendableEvent(characters: "i", modifiers: .control)
    static let ping = SendableEvent(characters: "l", modifiers: .control)
    static let undo = SendableEvent(characters: "/", modifiers: .control)

    static let toggleJisx0201Kana = SendableEvent(characters: "q", modifiers: .control)
    static let toggleKana = SendableEvent(characters: "q")

    static let enterJapanese = SendableEvent(characters: "Q", modifiers: .shift)
}
