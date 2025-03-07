//
//  SKKComposingEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import AquaSKKLogging
import Foundation
import OSLog

public class SKKComposingEditorImpl: SKKEditorProtocol {
    let context: SKKInputContext
    var composing: SKKTextBufferImpl

    public init(context: SKKInputContext) {
        self.context = context
        composing = SKKTextBufferImpl()
    }

    public func readContext() {
        composing.clear()

        if context.entry.IsEmpty() {
            // 直接入力モードからの遷移
            composing.insert(String(context.undo.entry))
        } else {
            // 変換モードからの遷移なので、見出し語を復元する
            context.entry.SetOkuri("", "")
            composing.insert(String(context.entry.EntryString()))
        }
        context.dynamic_completion = true
    }

    public func writeContext() {
        context.output.SetMark()
        context.output.Compose(std.string("▽\(composing.string)"), Int32(composing.cursorPosition))
        update()
    }

    private func update() {
        context.entry = SKKEntry(std.string(composing.leftString), "")
    }

    public func input(ascii: String) {
        composing.insert(ascii)
    }

    public func input(fixed: String, input _: String, code _: Int) {
        composing.insert(fixed)
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)
        inputEvent(event: event)
    }

    public func inputEvent(event: SKKBaseEditorEvent) {
        switch event {
        case SKKBaseEditorEventBackSpace:
            if composing.isEmpty {
                context.needs_setback = true
            }
            composing.backSpace()

        case SKKBaseEditorEventDelete:
            composing.delete()

        case SKKBaseEditorEventCursorLeft:
            composing.cursorLeft()

        case SKKBaseEditorEventCursorRight:
            composing.cursorRight()

        case SKKBaseEditorEventCursorUp:
            composing.cursorUp()

        case SKKBaseEditorEventCursorDown:
            composing.cursorDown()

        default:
            Logger.skkEngine.error("\(#function, privacy: .public) unkwon event")
        }
        update()
    }

    public func commit(queue _: String) -> String {
        return composing.string
    }

    public func setEntry(entry: String) {
        composing.clear()
        composing.insert(entry)
        update()
    }
}
