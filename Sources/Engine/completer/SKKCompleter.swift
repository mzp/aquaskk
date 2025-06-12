//
//  SKKCompleter.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

import AquaSKKBackend

public class SKKCompleterImpl {
    private let buddy: SKKCompleterBuddyProtcol
    private var completions: [String]
    private var position: Int

    public init(buddyProtocol buddy: SKKCompleterBuddyProtcol) {
        self.buddy = buddy
        completions = []
        position = 0
    }

    public func execute(limit: Int) -> Bool {
        let query = buddy.completerQueryString()
        position = 0
        completions = SKKBackendImpl.shared().complete(key: String(query), limit: limit)

        if !completions.isEmpty {
            notify()
        }
        return !completions.isEmpty
    }

    public func remove() -> Bool {
        guard !completions.isEmpty else {
            return false
        }
        let entry = SKKEntry(std.string(completions[position]), "")
        SKKBackendImpl.shared().remove(entry: entry, candidate: SKKCandidate())
        var tmp = SKKCandidateSuite()
        SKKBackendImpl.shared().find(entry: entry, to: &tmp)
        return !tmp.isEmpty
    }

    public func next() {
        guard !completions.isEmpty else {
            return
        }
        position = (position + 1) % completions.count
        notify()
    }

    public func prev() {
        guard !completions.isEmpty else {
            return
        }
        position = (position - 1) % completions.count
        notify()
    }

    private func notify() {
        buddy.completerUpdate(entry: completions[position])
    }
}
