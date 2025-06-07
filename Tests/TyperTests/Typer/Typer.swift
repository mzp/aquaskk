//
//  Typer.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//
@_spi(Testing) internal import AquaSKKInput
internal import AquaSKKTesting
import AppKit
import AquaSKKService
import InputMethodKit

class Typer {
    // MARK: - Session

    class Session {
        private var client = MockTextInput()
        @MainActor func run(config: MockConfigImpl, perform: (Typer) async -> Void) async {
            SKKBackendImpl.shared().privateModeEnabled = true

            // SKKInputControllerはMainThread以外からはさわれない
            // deinitもMainThreadで実行されるよう、このメソッドの外には出さない
            let controller = SKKInputController()
            let typerSession = TyperInputSessionParameterImpl(config: config, client: client)
            controller._setClient(client, sessionParameter: typerSession)
            controller.activateServer(nil)

            let typer = Typer(
                controller: controller,
                typerSession: typerSession,
                client: client
            )
            typer.clear()
            await perform(typer)
            controller.deactivateServer(nil)

            // 学習内容を初期化する
            SKKBackendImpl.shared().privateModeEnabled = false
        }

        @MainActor func run(perform: (Typer) async -> Void) async {
            await run(config: .defaults(), perform: perform)
        }
    }

    private let controller: SKKInputController
    private let client: MockTextInput
    private(set) var text = TyperState()
    private let typerSession: TyperInputSessionParameterImpl

    init(
        controller: SKKInputController,
        typerSession: TyperInputSessionParameterImpl,
        client: MockTextInput
    ) {
        self.controller = controller
        self.typerSession = typerSession
        self.client = client
    }

    // MARK: - Action

    func type(text: String, modifiers: NSEvent.ModifierFlags = []) async {
        for character in text {
            let event = TyperEvent(
                characters: String(character),
                modifiers: modifiers
            )
            await handle(event: event)
        }
    }

    func type(character: String, keycode: UInt16) async {
        let event = TyperEvent(
            characters: character,
            keyCode: keycode
        )
        await handle(event: event)
    }

    @discardableResult @MainActor func handle(event: TyperEvent) -> Bool {
        let handled = controller.handle(event.nsEvent, client: client)
        text = client.text
        return handled
    }

    // MARK: - Text Edit

    func setText(string: String, range: NSRange) {
        client.text.string = string
        client._selectedRange = range
    }

    func set(pasteString: String) {
        typerSession.setYankString(pasteString)
    }

    // MARK: - Menu

    var inputMode: SKKInputMode? {
        controller.skkInputMenu()?.currentInputMode
    }

    @MainActor func setValue(_ value: String) {
        controller.setValue(value, forTag: kTextServiceInputModePropertyTag, client: client)
    }

    // MARK: - Properties

    var insertedText: String {
        text.string
    }

    var markedText: String {
        text.marked
    }

    var markedTextRange: NSRange {
        text.markedTextRange
    }

    var modeIdentifier: String? {
        text.modeIdentifier
    }

    func clear() {
        client.text.clear()
    }

    // MARK: - Candidates

    var candidates: [String] {
        typerSession.candidates
    }

    var candidateCursor: Int {
        typerSession.candidateCursor
    }

    var candidatePage: Int {
        typerSession.candidatePage
    }

    // MARK: - Completion

    var completion: TyperCompletion {
        TyperCompletion(
            completion: typerSession.completion,
            prefixSize: typerSession.commonPrefixLength,
            cursorOffset: typerSession.cursorOffset,
            visible: typerSession.completionVisible
        )
    }

    // MARK: - Annotation

    var annotation: TyperAnnotation {
        TyperAnnotation(
            entry: typerSession.annotation,
            cursorIndex: typerSession.annotationCursor,
            visible: typerSession.annotationVisible
        )
    }
}
