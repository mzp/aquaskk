//
//  SKKNativeEncodingDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/20/25.
//

import AquaSKKLogging
import Foundation
import OSLog

protocol SKKDictionaryDataSource {
    var okuriAri: [SKKDictionaryEntryImpl] { get }
    var okuriNasi: [SKKDictionaryEntryImpl] { get }
}

/// 辞書の読み書き w/ 文字コード変換
class SKKEncodingDictionary {
    var dataSource: SKKDictionaryDataSource?

    let encoding: String.Encoding
    init(encoding: String.Encoding) {
        self.encoding = encoding
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

    func reverseLookup(candidate: String) -> String? {
        guard let entries = dataSource?.okuriNasi else {
            return nil
        }
        var parser = SKKCandidateParser()
        for entry in entries {
            let valueString = entry.valueString(using: encoding)
            parser.Parse(std.string(valueString))
            if parser.candidates.first(where: {
                String($0.variant) == candidate
            }) != nil {
                return entry.entryString(using: encoding)
            }
        }
        return nil
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
