//
//  Typer.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import AquaSKKInput_Private
import AquaSKKTesting
import Foundation

class Typer {
    // MARK: - Session

    class Session {
        private var client = MockTextInput()
        let sessionParameter = MockInputSessionParameter.newInstance()

        @MainActor func run(perform: (Typer) async -> Void) async {
            // SKKInputControllerはMainThread以外からはさわれない
            // deinitもMainThreadで実行されるよう、このメソッドの外には出さない
            let controller = SKKInputController()
            defer { controller.deactivateServer(nil) }
            controller._setClient(client, sessionParameter: sessionParameter)
            controller.activateServer(nil)

            let typer = Typer(controller: controller, client: client)
            await perform(typer)
            controller.deactivateServer(nil)
        }
    }

    private let controller: SKKInputController
    private let client: MockTextInput
    private(set) var text = SendableText()

    init(controller: SKKInputController, client: MockTextInput) {
        self.controller = controller
        self.client = client
    }

    // MARK: - Action

    func type(text: String) async {
        for character in text {
            let event = SendableEvent(characters: String(character))
            await handle(event: event)
        }
    }

    func type(character: String, keycode: UInt16) async {
        let event = SendableEvent(
            characters: character,
            keyCode: keycode
        )
        await handle(event: event)
    }

    @MainActor func handle(event: SendableEvent) {
        controller.handle(event.nsEvent, client: client)
        text = client.text
    }

    // MARK: - Properties

    var insertedText: String {
        text.string
    }

    var markedText: String {
        text.marked
    }

    var modeIdentifier: String? {
        text.modeIdentifier
    }
}
