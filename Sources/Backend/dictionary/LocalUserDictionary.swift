//
//  LocalUserDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/15/24.
//

import Foundation
import OSLog

private let kMaxIdleCount = 20
private let kMaxSaveInterval: TimeInterval = 60 * 5.0

extension SKKCompletionHelperBridge: CompletionHelper {
    public var entry: String {
        String(getEntry())
    }

    public var canContinue: Bool {
        CanContinue()
    }

    public mutating func add(completion: String) {
        Add(std.string(completion))
    }
}

public class LocalUserDictionary {
    private var path: String?
    private var idleCount = 0
    private var lastUpdate = Date()
    private var file = DictionaryFile()

    private(set) var privateMode: Bool = false

    public init() {}

    public func initialize(path: String) {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            do {
                try await initialize(path: path)
            } catch {
                Logger.backend.error("\(#function, privacy: .public) can't load file: \(path, privacy: .private) due to \(error)")
            }
        }
        semaphore.wait()
    }

    public func initialize(path: String) async throws {
        if let oldPath = self.path {
            if path == oldPath {
                return
            }
            try save(force: true)
        }
        self.path = path
        idleCount = 0
        lastUpdate = Date()

        try await file.load(path: path)
        fix()
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        var suite = SKKCandidateSuite()

        if entry.IsOkuriAri() {
            let rawValue = fetch(entry: entry, from: file.okuriAri)
            suite.Parse(std.string(rawValue))

            var strict = SKKCandidateSuite()
            if suite.FindOkuriStrictly(entry.OkuriString(), &strict) {
                strict.Add(suite.hints)
                suite = strict
            }
        } else {
            let rawValue = fetch(entry: entry, from: file.okuriNasi)
            suite.Parse(std.string(rawValue))

            for var candidate in suite.getCandidates() {
                candidate.Decode()
            }
        }

        result.Add(suite)
    }

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: CompletionHelper = helper
        complete(helper: &tmp)
    }

    public func complete(helper: inout CompletionHelper) {
        let query = helper.entry
        for entry in file.okuriNasi {
            if !entry.entry.hasPrefix(query) {
                continue
            }
            helper.add(completion: entry.entry)

            if !helper.canContinue {
                break
            }
        }
    }

    public func reverseLookup(candidate: String) -> String {
        let entries = file.okuriNasi.filter { entry in
            entry.rawValue.contains("/\(candidate)")
        }

        var parser = SKKCandidateParser()
        let query = SKKCandidate(std.string(candidate), true)
        for entry in entries {
            parser.Parse(std.string(entry.rawValue))
            if parser.candidates.contains(where: { $0 == query }) {
                return entry.entry
            }
        }

        return ""
    }

    public func register(entry: SKKEntry, candidate: SKKCandidate) -> Bool {
        if entry.IsOkuriAri() {
            var hint = SKKOkuriHint(
                first: entry.OkuriString(),
                second: .init()
            )
            hint.second.push_back(SKKCandidate(candidate.ToString(), true))

            update(entry: entry, at: &file.okuriAri) { suite in
                suite.Update(hint)
            }
        } else {
            var tmp = candidate
            tmp.Encode()
            update(entry: entry, at: &file.okuriNasi) { suite in
                suite.Update(tmp)
            }
        }

        do {
            try save(force: false)
            return true
        } catch {
            Logger.backend.error("\(#function, privacy: .public) can't register word due to \(error)")
            return false
        }
    }

    public func remove(entry: SKKEntry, candidate: SKKCandidate) {
        if entry.IsOkuriAri() {
            remove(entry: entry, candidate: candidate, from: &file.okuriAri)
        } else {
            var tmp = candidate
            tmp.Encode()

            remove(
                entry: entry,
                candidate: tmp,
                from: &file.okuriNasi
            )
        }
    }

    public func setPrivateMode(value: Bool) {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            if value != privateMode {
                if value {
                    try save(force: true)
                } else if let path = path {
                    try await file.load(path: path)
                }
                privateMode = value
            }
            semaphore.signal()
        }
        semaphore.wait()
    }

    private func fetch(entry: SKKEntry, from container: DictionaryEntryContainer) -> String {
        guard let entry = container.first(where: { $0.entry == String(entry.EntryString()) }) else {
            return ""
        }
        return entry.rawValue
    }

    private func remove(
        entry: SKKEntry,
        candidate: SKKCandidate,
        from container: inout DictionaryEntryContainer
    ) {
        let query = String(entry.EntryString())
        guard let index = container.firstIndex(where: { $0.entry == query }) else {
            return
        }

        var suite = SKKCandidateSuite()
        suite.Parse(std.string(container[index].rawValue))
        suite.Remove(candidate)

        if suite.IsEmpty() {
            container.remove(at: index)
        } else {
            container[index].rawValue = String(suite.ToString())
        }
    }

    private func update(
        entry: SKKEntry,
        at container: inout DictionaryEntryContainer,
        perform: (inout SKKCandidateSuite) -> Void
    ) {
        var suite = SKKCandidateSuite()
        let query = String(entry.EntryString())

        if let index = container.firstIndex(where: { $0.entry == query }) {
            suite.Parse(std.string(container[index].rawValue))
            container.remove(at: index)
        }
        perform(&suite)
        container.insert(.init(entry: query, rawValue: String(suite.ToString())), at: 0)
    }

    private func save(force: Bool) throws {
        guard let path = path else {
            return
        }
        guard !privateMode else {
            return
        }
        let now = Date()
        if !force {
            idleCount += 1

            guard kMaxIdleCount < idleCount else {
                return
            }
            let interval = now.timeIntervalSince(lastUpdate)
            guard kMaxSaveInterval < interval else {
                return
            }
        }

        idleCount = 0
        lastUpdate = now

        let tmpPath = "\(path).tmp"

        do {
            try file.save(path: tmpPath)
        } catch {
            Logger.backend.error("\(#function, privacy: .public) can't save: \(tmpPath, privacy: .private)")
            throw error
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            try FileManager.default.moveItem(atPath: tmpPath, toPath: path)
            Logger.backend.error("\(#function, privacy: .public) saved")
        } catch {
            Logger.backend.error("\(#function, privacy: .public) rename failed due to  \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    private func fix() {
        // ユーザー辞書の "#" は無意味なのでまるごと削除する
        file.okuriNasi.removeAll(where: {
            $0.entry == "#"
        })
    }
}
