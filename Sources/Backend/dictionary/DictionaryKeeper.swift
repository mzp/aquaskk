//
//  DictionaryKeeper.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/30/24.
//

import Foundation
import OSLog
import CxxStdlib


class DictionaryKeeper {
    enum Encoding {
        case eucjp
        case utf8
    }
    var timer: Timer?
    var file = DictionaryFile()
    var loaded: Bool = false
    var needsConversion: Bool
    var timeout: TimeInterval = 0
    var condition = NSCondition()

    init(encoding: Encoding) {
        needsConversion = (encoding == .eucjp)
    }

    func initialize(loader: DictionaryLoader) {
        guard timer == nil else {
            Logger.backend.warning("\(#function): already initilazed")
            return
        }
        loader.delegate = self
        timeout = loader.timeout()
        self.timer = 
            .scheduledTimer(
                withTimeInterval: loader.interval(),
                repeats: true) { _ in
                    loader.run()
                }

    }

    func findOkuriAri(query: String) -> String {
        return fetch(query: query, container: file.okuriAri)
    }
    func findOkuriNasi(query: String) -> String {
        return fetch(query: query, container: file.okuriNasi)
    }

    var ready: Bool {
        if loaded {
            return true
        }
        if !condition.wait(until: Date(timeIntervalSinceNow: timeout)) {
            return false
        }
        return true
    }

    // TODO: Use async
    func reverseLookup(candidate: String) -> String {
        condition.lock()
        defer { condition.unlock() }

        guard ready else {
            return ""
        }
        let container = file.okuriNasi
        var parser = SKKCandidateParser()
        let entries = container.filter({ entry in
            entry.rawValue.contains("/\(candidate)")
        })
        for entry in entries {
            parser.Parse(std.string(internalEncoding(from: entry.rawValue)))
            let suite = parser.getCandidates()
            if suite.contains(where: {
                $0 == SKKCandidate(std.string(candidate), true)
            }) {
                return internalEncoding(from: entry.entry)
            }
        }
        return "";
    }

    func complete(helper: inout CompletionHelper) {
        condition.lock()
        defer { condition.unlock() }

        guard ready else {
            return
        }

        let container = file.okuriNasi
        let query = helper.entry
        for entry in container {
            guard entry.entry.hasPrefix(query) else {
                continue
            }
            let completion = internalEncoding(from: entry.entry)
            helper.append(completion: completion)
            if !helper.canContinue {
                return
            }
        }
    }

    private func externalEncoding(from src: String) -> Data? {
        if needsConversion {
            return src.data(using: .japaneseEUC)
        } else {
            return src.data(using: .utf8)
        }
    }

    private func internalEncoding(from src: String) -> String {
        if needsConversion {
            // return SKKEncoding::utf8_from_eucj(src);
            return src
        }
        return src
    }

    private func fetch(query: String, container: DictionaryEntryContainer) -> String {
        condition.lock()
        defer { condition.unlock() }

        guard ready else {
            return ""
        }

        let index = DictionaryEntry(entry: query, rawValue: "")
        let element = binarySearch(
            index,
            from: container,
            startIndex: container.startIndex,
            endIndex: container.endIndex,
            by: { lhs, rhs in
                lhs.entry < rhs.entry
            }
        )

        return element?.rawValue ?? ""
    }
}

extension DictionaryKeeper: DictionaryLoaderDelegate {
    func dictionaryLoaderDidUpdate(file: DictionaryFile) {
        self.file = file
        loaded = true
        condition.signal()
    }
}
