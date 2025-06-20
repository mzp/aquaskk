//
//  SKKCandidateEditor.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/05.
//

import AquaSKKBackend

public class SKKCandidateEditorImpl: SKKEditorProtocol {
    let context: SKKInputContextImpl
    private var entry: SKKEntryBridge
    private var candidate: SKKCandidateBridge
    init(context: SKKInputContextImpl) {
        self.context = context
        entry = .init()
        candidate = .init(string: "", autoParse: true)
    }

    public func readContext() {
        entry = context.entry
        context.annotation = true
    }

    public func writeContext() {
        var str = String(candidate.variant)
        if entry.isOkuriAri {
            str += entry.okuriString
        }
        context.output.setMark()
        context.output.convert(string: "▼\(str)")
    }

    public func input(ascii _: String) {}

    public func input(fixed _: String, input _: String, code _: Int) {}

    public func inputEvent(event _: SKKBaseEditorEvent) {}

    public func commit(queue _: String) -> String {
        SKKBackendImpl.shared().register(entry: entry.copy(), candidate: candidate.copy())
        var queue = String(candidate.variant)
        if entry.isOkuriAri {
            queue += entry.okuriString
        }
        return queue
    }

    public func bridgeSetCandidate(candidateString: String) {
        let candidate = SKKCandidateBridge(string: candidateString, autoParse: true)
        setCandidate(candidate: candidate)
    }

    func setCandidate(candidate: SKKCandidateBridge) {
        self.candidate = candidate
        update()
    }

    private func update() {
        context.entry = entry
        context.candidate = candidate
    }
}
