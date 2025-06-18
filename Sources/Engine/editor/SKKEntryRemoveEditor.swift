//
//  SKKEntryRemoveEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import AquaSKKBackend

public class SKKEntryRemoveEditorImpl: SKKEditorProtocol {
    let context: SKKInputContext
    var input: String
    var prompt: String
    var entry: SKKEntryBridge
    var candidate: SKKCandidateBridge

    public init(context: SKKInputContext) {
        self.context = context
        input = ""
        prompt = ""
        entry = SKKEntryBridge()
        candidate = .init()
    }

    public func readContext() {
        entry = context.entry
        candidate = context.candidate
        input.removeAll()
        prompt = "\(entry.entryString) /\(candidate.stringValue)/ を削除しますか？(yes/no) "
    }

    public func writeContext() {
        context.output.clear()
        context.output.compose(string: prompt + input)
        context.entry = entry
    }

    public func input(ascii: String) {
        input += ascii
    }

    public func input(fixed: String, input _: String, code _: Int) {
        input += fixed
    }

    public func bridgeInputEvent(_ rawValue: UInt32) {
        let event = SKKBaseEditorEvent(rawValue: rawValue)!
        inputEvent(event: event)
    }

    public func inputEvent(event: SKKBaseEditorEvent) {
        if event == .SKKBaseEditorEventBackSpace, !input.isEmpty {
            input.removeLast()
        }
    }

    public func commit(queue _: String) -> String {
        if input == "yes" {
            context.needs_setback = true
        } else {
            SKKBackendImpl.shared().remove(entry: entry.copy(), candidate: candidate.copy())
        }
        return ""
    }
}
