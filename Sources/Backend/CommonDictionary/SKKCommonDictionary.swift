//
//  SKKCommonDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import Foundation
import Combine
import AquaSKKLogging
import OSLog

// 標準的な SKK 辞書実装
public class SKKCommonDictionary: SKKBaseDictionaryProtocol {
    private let reader: SKKDictionaryReader
    private let source: SKKDictionarySourceProtocol
    private var timer: Timer?
    init(encoding: String.Encoding, source: SKKDictionarySourceProtocol) {
        reader = .init(encoding: encoding)
        self.source = source
    }

    public func initialize(path: String) async throws {
        reader.dataSource = nil
        timer?.invalidate()

        source.initialize(location: path)
        timer = .scheduledTimer(withTimeInterval: source.interval, repeats: true) { [weak self] _ in
            if self?.source.needsUpdate == true {
                Task { try await self?.loadIfNeeded() }
            }
        }
        try await self.loadIfNeeded()
    }

    private func loadIfNeeded() async throws {
        guard let path = source.path else {
            return
        }
        guard source.needsUpdate || reader.dataSource == nil else {
            return
        }
        let file = SKKDictionaryFileImpl()
        try await file.load(path: path)
        file.sort()

        reader.dataSource = file
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        var suite = SKKCandidateSuite()
        let query = String(entry.EntryString())
        if entry.IsOkuriAri() {
            let rawValue = reader.findOkuriAri(query: query)
            suite.Parse(std.string(rawValue))

            var strict = SKKCandidateSuite()
            if suite.FindOkuriStrictly(entry.OkuriString(), &strict) {
                strict.Add(suite.hints)
                suite = strict
            }
        } else {
            let rawValue = reader.findOkuriNasi(query: query)
            suite.Parse(std.string(rawValue))
        }
        result.Add(suite)
    }

    public func complete(helper: inout any SKKCompletionHelperProtocol) {
        reader.complete(helper: &helper)
    }

    public func reverseLookup(candidate: String) -> String {
        return reader.reverseLookup(candidate: candidate) ?? ""
    }
}

public class SKKCommonDictionaryUTF8: SKKCommonDictionary {
    public init() {
        super.init(encoding: .utf8, source: SKKDictionaryLocalSource())
    }
}

public class SKKCommonDictionaryEUCJP: SKKCommonDictionary {
    public init() {
        super.init(encoding: .japaneseEUC, source: SKKDictionaryLocalSource())
    }
}
