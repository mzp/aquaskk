//
//  SKKCommonDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import AquaSKKLogging
import OSLog

// 標準的な SKK 辞書実装

public class SKKCommonDictionaryUTF8: SKKDictionaryReloadAdapter {
    public init() {
        super.init(
            baseDictionary: SKKEncodingDictionary(encoding: .utf8),
            source: SKKLocalDictionaryFileSource()
        )
    }

    // MARK: - C++ Adapter

    public func initialize(path: String) {
        SKKTask.perfromAndWait {
            do {
                try await self.initialize(path: path)
            } catch {
                Logger.backend.error("\(#function, privacy: .public) can't load file: \(path, privacy: .private) due to \(error)")
            }
        }
    }

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }
}

public class SKKCommonDictionaryEUCJP: SKKDictionaryReloadAdapter {
    public init() {
        super.init(
            baseDictionary: SKKEncodingDictionary(encoding: .japaneseEUC),
            source: SKKLocalDictionaryFileSource()
        )
    }

    // MARK: - C++ Adapter

    public func initialize(path: String) {
        SKKTask.perfromAndWait {
            do {
                try await self.initialize(path: path)
            } catch {
                Logger.backend.error("\(#function, privacy: .public) can't load file: \(path, privacy: .private) due to \(error)")
            }
        }
    }

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }
}

public class SKKAutoUpdateDictionary: SKKDictionaryReloadAdapter {
    private let source: SKKHttpDictionaryFileSource

    public init() {
        source = SKKHttpDictionaryFileSource()
        super.init(
            baseDictionary: SKKEncodingDictionary(encoding: .japaneseEUC),
            source: source
        )
    }

    // MARK: - C++ Adapter

    public func initialize(path: String) {
        SKKTask.perfromAndWait {
            do {
                try await self.initialize(path: path)
            } catch {
                Logger.backend.error("\(#function, privacy: .public) can't load file: \(path, privacy: .private) due to \(error)")
            }
        }
    }

    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }

    // MARK: - For unittest

    @_spi(Testing) public func refresh() async throws {
        try await source.refresh()
    }
}
