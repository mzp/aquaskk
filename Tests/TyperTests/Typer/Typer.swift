//
//  Typer.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//
import AquaSKKInput_Private
internal import AquaSKKTesting
import Foundation

struct TyperCompletion {
    var completion: String
    var prefixSize: Int
    var cursorOffset: Int
    var visible: Bool
}

struct TyperAnnotation {
    var entry: String
    var cursorIndex: Int
    var visible: Bool
}

class Typer {
    // MARK: - Session

    class Session {
        private var client = MockTextInput()

        @MainActor func run(perform: (Typer) async -> Void) async {
            // SKKInputControllerはMainThread以外からはさわれない
            // deinitもMainThreadで実行されるよう、このメソッドの外には出さない
            let controller = SKKInputController()
            let typerSession = TyperInputSessionParameter.Create(client)
            let ptr = TyperInputSessionParameter.Coerce(typerSession)
            controller._setClient(client, sessionParameter: ptr)
            controller.activateServer(nil)

            let typer = Typer(
                controller: controller,
                typerSession: typerSession,
                client: client
            )
            await perform(typer)
            controller.deactivateServer(nil)
        }
    }

    private let controller: SKKInputController
    private let client: MockTextInput
    private(set) var text = SendableText()
    private let typerSession: TyperInputSessionParameter

    init(
        controller: SKKInputController,
        typerSession: TyperInputSessionParameter,
        client: MockTextInput
    ) {
        self.controller = controller
        self.typerSession = typerSession
        self.client = client
    }

    // MARK: - Action

    func type(text: String, modifiers: NSEvent.ModifierFlags = []) async {
        for character in text {
            let event = SendableEvent(
                characters: String(character),
                modifiers: modifiers
            )
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

    func set(pasteString: String) {
        typerSession.SetString(std.string(pasteString))
    }

    var candidates: [String] {
        Array(typerSession.Candidates().map { String($0) })
    }

    var completion: TyperCompletion {
        TyperCompletion(
            completion: String(typerSession.GetCompletion()),
            prefixSize: Int(typerSession.GetCommonPrefixSize()),
            cursorOffset: Int(typerSession.GetCursorOffset()),
            visible: typerSession.IsCompletionVisible()
        )
    }

    var annotation: TyperAnnotation {
        TyperAnnotation(
            entry: String(typerSession.GetAnnotation().ToString()),
            cursorIndex: Int(typerSession.GetAnnotationCursor()),
            visible: typerSession.IsAnnotationVisible()
        )
    }
}
