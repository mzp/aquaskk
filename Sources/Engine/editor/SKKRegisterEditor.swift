//
//  SKKRegisterEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

import AquaSKKBackend
import AquaSKKLogging
import OSLog

public class SKKRegisterEditorImpl: SKKEditorProtocol {
    private let context: SKKInputContext
    private var entry: SKKEntry
    private var word: SKKTextBufferImpl
    private var prompt: String

    public init(context: SKKInputContext) {
        self.context = context
        entry = context.entry
        word = .init()
        prompt = "[登録：\(String(entry.PromptString()))]"
    }

    public func readContext() {
        context.entry = .init()
        word.insert(String(context.registration.word))
        context.registration.Clear()
    }

    public func writeContext() {
        context.output.compose(string: "\(prompt)\(word.string)", cursor: word.cursorPosition)
    }

    public func input(ascii: String) {
        word.insert(ascii)
    }

    public func input(fixed: String, input _: String, code _: Int) {
        word.insert(fixed)
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)
        inputEvent(event: event)
    }

    public func inputEvent(event: SKKBaseEditorEvent) {
        switch event {
        case SKKBaseEditorEventBackSpace:
            word.backSpace()
        case SKKBaseEditorEventDelete:
            word.delete()
        case SKKBaseEditorEventCursorLeft:
            word.cursorLeft()
        case SKKBaseEditorEventCursorRight:
            word.cursorRight()
        case SKKBaseEditorEventCursorUp:
            word.cursorUp()
        case SKKBaseEditorEventCursorDown:
            word.cursorDown()
        default:
            Logger.skkEngine.warning("\(#function, privacy: .public): Unsupported event")
        }
    }

    public func commit(queue: String) -> String {
        word.insert(queue)
        context.entry = entry
        return word.string
    }
}
