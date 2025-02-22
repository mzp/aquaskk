//
//  SKKEncodingDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/20/25.
//

import AquaSKKLogging
import Foundation
import OSLog

public protocol SKKDictionaryDataSource {
    var okuriAri: [SKKDictionaryEntryImpl] { get }
    var okuriNasi: [SKKDictionaryEntryImpl] { get }
}

/// 辞書の読み書き w/ 文字コード変換
class SKKEncodingDictionary: SKKBaseDictionaryProtocol {
    @_spi(Testing)
    public var dataSource: SKKDictionaryDataSource?

    let encoding: String.Encoding
    init(encoding: String.Encoding) {
        self.encoding = encoding
    }

    func initialize(path: String) async throws {
        let file = SKKDictionaryFileImpl()
        try await file.load(path: path)
        file.sort()
        dataSource = file
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        var suite = SKKCandidateSuite()
        let query = String(entry.EntryString())
        if entry.IsOkuriAri() {
            if let rawValue = findOkuriAri(query: query) {
                suite.Parse(std.string(rawValue))

                var strict = SKKCandidateSuite()
                if suite.FindOkuriStrictly(entry.OkuriString(), &strict) {
                    strict.Add(suite.hints)
                    suite = strict
                }
            }
        } else {
            if let rawValue = findOkuriNasi(query: query) {
                suite.Parse(std.string(rawValue))
            }
        }
        result.Add(suite)
    }

    func findOkuriAri(query: String) -> String? {
        guard let dataSource = dataSource else {
            return nil
        }
        return fetch(query: query, entries: dataSource.okuriAri)
    }

    func findOkuriNasi(query: String) -> String? {
        guard let dataSource = dataSource else {
            return nil
        }
        return fetch(query: query, entries: dataSource.okuriNasi)
    }

    private func fetch(query: String, entries: [SKKDictionaryEntryImpl]) -> String? {
        let entry = entries.first(where: {
            $0.entryString(using: encoding) == query
        })
        return entry?.valueString(using: encoding)
    }

    func reverseLookup(candidate: String) -> String {
        guard let entries = dataSource?.okuriNasi else {
            return ""
        }
        var parser = SKKCandidateParser()
        for entry in entries {
            guard let valueString = entry.valueString(using: encoding) else {
                continue
            }
            parser.Parse(std.string(valueString))
            if parser.candidates.first(where: {
                String($0.variant) == candidate
            }) != nil {
                return entry.entryString(using: encoding) ?? ""
            }
        }
        return ""
    }

    func complete(helper: inout SKKCompletionHelperProtocol) {
        guard let entries = dataSource?.okuriNasi else {
            return
        }

        let query = helper.entry
        for entry in entries {
            guard let entryString = entry.entryString(using: encoding) else {
                Logger.skkBackend.error("\(#function, privacy: .public) invalid encoding")
                continue
            }
            guard entryString.hasPrefix(query) else {
                continue
            }
            helper.add(completion: entryString)

            if !helper.canContinue {
                break
            }
        }
    }
}
