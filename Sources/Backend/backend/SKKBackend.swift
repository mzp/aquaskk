//
//  SKKBackend.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/23.
//

import AquaSKKLogging
import Foundation
import OSLog
import AquaSKKService

struct DictionaryConfiguration {
    var type: JisyoType
    var location: String

    init?(from key: SKKDictionaryKey) {
        guard let type = JisyoType(rawValue: Int(key.first)) else {
            return nil
        }
        self.type = type
        location = String(key.second)
    }
}

public class SKKBackend {
    static let sharedInstance = SKKBackend()
    static func shared() -> SKKBackend { sharedInstance }
    public init() {}

    //     void Initialize(const std::string &userdict_path, const SKKDictionaryKeyContainer &keys);
    // bridge
    public func initialize(path: String, dictionaries: SKKDictionaryKeyContainer) {
        self.initialize(user: path, configurations: dictionaries.compactMap { .init(from: $0) })
    }

    func initialize(user: String, configurations: [DictionaryConfiguration]) {

    }


    // MARK: - SKKBaseDictionaryProtocol

    public func find(entry _: SKKEntry, to _: inout SKKCandidateSuite) {}

    public func complete(key: String, limit: Int) {

    }

    public func reverseLookup(candidate _: String) -> String {
        return ""
    }

    // MARK: - SKKUserDictionaryProtocol

    public func register(entry _: SKKEntry, candidate _: SKKCandidate) -> Bool {
        return true
    }

    public func remove(entry _: SKKEntry, candidate _: SKKCandidate) {}

    // MARK: - Properties
    public func setNumericConversionEnabled(enabled: Bool) {}
    public func setExtendedCompletionEnabled(enabled: Bool) {}
    public func setPrivateModeEnabled(enabled: Bool) {}
    public func setMinimumCompletionLength(length: Int) {}
}
