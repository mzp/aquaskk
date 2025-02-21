//
//  SKKDictionaryReloadAdapter.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import AquaSKKLogging
import Combine
import Foundation
import OSLog

public class SKKDictionaryReloadAdapter: SKKBaseDictionaryProtocol {
    private let baseDictionary: SKKBaseDictionaryProtocol
    private let source: SKKDictionarySourceFileProtocol
    private var timer: Timer?
    init(baseDictionary: SKKBaseDictionaryProtocol, source: SKKDictionarySourceFileProtocol) {
        self.baseDictionary = baseDictionary
        self.source = source
    }

    public func initialize(path: String) async throws {
        timer?.invalidate()

        source.initialize(location: path)
        timer = .scheduledTimer(withTimeInterval: source.interval, repeats: true) { [weak self] _ in
            if self?.source.needsUpdate == true {
                Task { try await self?.loadIfNeeded(force: false) }
            }
        }
        try await loadIfNeeded(force: true)
    }

    private func loadIfNeeded(force: Bool) async throws {
        guard let path = source.path else {
            return
        }
        guard source.needsUpdate || force else {
            return
        }
        try await baseDictionary.initialize(path: path)
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        baseDictionary.find(entry: entry, to: &result)
    }

    public func complete(helper: inout any SKKCompletionHelperProtocol) {
        baseDictionary.complete(helper: &helper)
    }

    public func reverseLookup(candidate: String) -> String {
        return baseDictionary.reverseLookup(candidate: candidate)
    }
}
