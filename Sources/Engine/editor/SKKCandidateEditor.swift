//
//  SKKCandidateEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import AquaSKKBackend

public class SKKCandidateEditorImpl: SKKEditorProtocol {
    let context: SKKInputContext
    private var entry: SKKEntry
    private var candidate: SKKCandidate
    public init(context: SKKInputContext) {
        self.context = context
        entry = .init()
        candidate = .init("", true)
    }

    public func readContext() {
        entry = context.entry
        context.annotation = true
    }

    public func writeContext() {
        var str = String(candidate.variant)
        if entry.IsOkuriAri() {
            str += String(entry.OkuriString())
        }
        context.output.setMark()
        context.output.convert(string: "▼\(str)")
    }

    public func input(ascii _: String) {}

    public func input(fixed _: String, input _: String, code _: Int) {}

    public func inputEvent(event _: SKKBaseEditorEvent) {}

    public func commit(queue _: String) -> String {
        SKKBackendImpl.shared().register(entry: entry, candidate: candidate)
        var queue = String(candidate.variant)
        if entry.IsOkuriAri() {
            queue += String(entry.OkuriString())
        }
        return queue
    }

    public func bridgeSetCandidate(candidateString: String) {
        let candidate = SKKCandidate(std.string(candidateString), true)
        setCandidate(candidate: candidate)
    }

    func setCandidate(candidate: SKKCandidate) {
        self.candidate = candidate
        update()
    }

    private func update() {
        context.entry = entry
        context.candidate = candidate
    }
}
