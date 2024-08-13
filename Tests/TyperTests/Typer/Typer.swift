//
//  Typer.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import AquaSKKIM_Private
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

class Typer {
    var text: String {
        client.text
    }

    var markedText: String {
        client.markedText
    }

    var modeIdentifier: String? {
        client.modeIdentifier
    }

    private var client: TyperTextInput
    private var controller: SKKInputController?

    @MainActor
    init() {
        let client = TyperTextInput()
        let controller = SKKInputController()
        controller._setClient(client)

        self.client = client
        self.controller = controller

        controller.activateServer(nil)
    }

    deinit {
        controller?.deactivateServer(nil)
        controller = nil
    }

    func type(text: String) {
        for character in text {
            let event = TyperEvent(characters: String(character))
            handle(event: event)
        }
    }

    func type(character: String, keycode: UInt16) {
        let event = TyperEvent(
            characters: character,
            keyCode: keycode
        )
        handle(event: event)
    }

    private func handle(event: TyperEvent) {
        controller?.handle(event.nsEvent, client: client)
    }
}
