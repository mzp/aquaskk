//
//  SKKEntryRemoveEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import AquaSKKBackend

public class SKKEntryRemoveEditorImpl {
    let context: SKKInputContext
    var input: String
    var prompt: String
    var entry: SKKEntry
    var candidate: SKKCandidate

    public init(context: SKKInputContext) {
        self.context = context
        input = ""
        prompt = ""
        entry = SKKEntry()
        candidate = SKKCandidate()
    }

    public func readContext() {
        entry = context.entry
        candidate = context.candidate
        input.removeAll()
        prompt = "\(entry.EntryString()) /\(candidate.ToString())/ を削除しますか？(yes/no) "
    }

    public func writeContext() {
        context.output.Clear()
        context.output.Compose(std.string(prompt + input))
        context.entry = entry
    }

    public func input(ascii: String) {
        input += ascii
    }

    public func input(fixed: String, input _: String, code _: CChar) {
        input += fixed
    }

    public func inputEvent(event: SKKBaseEditorEvent) {
        if event == SKKBaseEditorEventBackSpace, !input.isEmpty {
            input.removeLast()
        }
    }

    public func commit(queue _: String) -> String {
        if input == "yes" {
            context.needs_setback = true
        } else {
            SKKBackendImpl.shared().remove(entry: entry, candidate: candidate)
        }
        return ""
    }
}
