//
//  SKKBackendImpl.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/23.
//

import AquaSKKLogging
import AquaSKKService
import Foundation
import OSLog

public class SKKBackendImpl {
    static let sharedInstance = SKKBackendImpl()
    static func shared() -> SKKBackendImpl { sharedInstance }

    var userDictionary: SKKLocalUserDictionaryImpl
    var dictionaries: [SKKBaseDictionaryProtocol]
    public init() {
        userDictionary = .init()
        dictionaries = []

        numericConversionEnabled = true
        extendedCompletionEnabled = true
        privateModeEnabled = false
        minimumCompletionLength = 0
    }

    public func initialize(path: String, dictionaries: SKKDictionaryKeyContainer) {
        SKKTask.perfromAndWait {
            await self.initialize(path: path, configurations: dictionaries.compactMap { .init(from: $0) })
        }
    }

    func initialize(path: String, configurations: [SKKDictionaryConfiguration]) async {
        do {
            try await userDictionary.initialize(path: path)

            var dicts = [SKKBaseDictionaryProtocol]()
            for configuration in configurations {
                if let dict = try await create(configuration: configuration) {
                    dicts.append(dict)
                }
            }
            dictionaries = [userDictionary] + dicts
        } catch {
            Logger.skkBackend.error("\(#function, privacy: .public) error: \(error, privacy: .public)")
        }
    }

    /// Factory
    func create(configuration: SKKDictionaryConfiguration) async throws -> SKKBaseDictionaryProtocol? {
        let dict: SKKBaseDictionaryProtocol?
        switch configuration.type {
        case .common:
            dict = SKKCommonDictionaryEUCJP()

        case .commonUTF8:
            dict = SKKCommonDictionaryUTF8()

        case .autoUpdate:
            dict = SKKAutoUpdateDictionary()

        case .proxy:
            dict = SKKProxyDictionary()

        case .gadget:
            dict = SKKGadgetDictionaryImpl()

        case .kotoeri:
            Logger.skkBackend.warning("\(#function, privacy: .public) Kotoeri dictionary is no longer supported")
            dict = nil

        @unknown default:
            Logger.skkBackend.error("\(#function, privacy: .public) Unknown dictionary type")
            dict = nil
        }
        try await dict?.initialize(path: configuration.location)
        return dict
    }

    public func find(entry: SKKEntry, to result: inout SKKCandidateSuite) {
        for dictionary in dictionaries {
            dictionary.find(entry: entry, to: &result)
        }
        if !entry.IsOkuriAri() {
            let converter = NumericConverter()
            if numericConversionEnabled, converter.setup(String(entry.EntryString())) {
                for dictionary in dictionaries {
                    let normalized = SKKEntry(std.string(converter.normalizedKey), "")
                    dictionary.find(entry: normalized, to: &result)
                }
                for var candidate in result.candidates {
                    converter.apply(candidate: &candidate)
                }
                result.Remove(SKKCandidate(std.string(converter.originalKey), true))
            }
        }
        for candidate in result.candidates {
            if String(candidate.word).hasPrefix("(skk-ignore-dic-word") {
                result.Remove(candidate)
            }
        }
    }

    public func complete_(key: String, limit: Int) -> SKKCompletionResult {
        let backendHelper = SKKBackendCompletionHelper(entry: key, minimumLength: minimumCompletionLength, limit: limit)

        if key.isEmpty || !extendedCompletionEnabled {
            var helper: any SKKCompletionHelperProtocol = backendHelper
            userDictionary.complete(helper: &helper)
        } else {
            var helper: any SKKCompletionHelperProtocol = backendHelper
            for dictionary in dictionaries {
                dictionary.complete(helper: &helper)
            }
        }
        return .init(backendHelper.result.map { std.string($0) })
    }

    public func reverseLookup(candidate: String) -> String {
        guard !candidate.isEmpty else {
            return ""
        }
        for dictionary in dictionaries {
            let entry = dictionary.reverseLookup(candidate: candidate)

            if !entry.isEmpty {
                return entry
            }
        }
        return ""
    }

    public func register(entry: SKKEntry, candidate: SKKCandidate) {
        if entry.EntryString().isEmpty {
            return
        }
        if entry.IsOkuriAri(), entry.OkuriString().empty() || candidate.IsEmpty() {
            return
        }
        guard !candidate.AvoidStudy() else {
            return
        }

        _ = userDictionary.register(entry: normalize(entry: entry), candidate: candidate)
    }

    private func normalize(entry: SKKEntry) -> SKKEntry {
        if entry.IsOkuriAri() {
            return entry
        }
        let converter = NumericConverter()
        var result = entry
        if numericConversionEnabled, converter.setup(String(entry.EntryString())) {
            if converter.normalizedKey != "#" {
                result.SetEntry(std.string(converter.normalizedKey))
            }
        }
        return result
    }

    public func remove(entry: SKKEntry, candidate: SKKCandidate) {
        if entry.EntryString().isEmpty {
            return
        }
        userDictionary.remove(entry: entry, candidate: candidate)
    }

    // MARK: - Properties

    public var numericConversionEnabled: Bool
    public var extendedCompletionEnabled: Bool
    public var privateModeEnabled: Bool
    public var minimumCompletionLength: Int
}
