//
//  TyperEvent.swift
//  TyperTests
//
//  Created by mzp on 8/13/24.
//

import AppKit
import Foundation

struct TyperEvent: Sendable {
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

extension TyperEvent {
    static let skkEnter = TyperEvent(characters: "m", modifiers: .control)
    static let skkJmode = TyperEvent(characters: "j", modifiers: .control)
    static let skkCancel = TyperEvent(characters: "g", modifiers: .control)
    static let skkBackspace = TyperEvent(characters: "h", modifiers: .control)
    static let skkDelete = TyperEvent(characters: "d", modifiers: .control)
    static let skkLeft = TyperEvent(characters: "b", modifiers: .control)
    static let skkRight = TyperEvent(characters: "f", modifiers: .control)
    static let skkUp = TyperEvent(characters: "a", modifiers: .control)
    static let skkDown = TyperEvent(characters: "e", modifiers: .control)
    static let skkTab = TyperEvent(characters: "i", modifiers: .control)
    static let ping = TyperEvent(characters: "l", modifiers: .control)
    static let undo = TyperEvent(characters: "/", modifiers: .control)

    static let toggleJisx0201Kana = TyperEvent(characters: "q", modifiers: .control)
    static let toggleKana = TyperEvent(characters: "q")

    static let enterJapanese = TyperEvent(characters: "Q", modifiers: .shift)
}
