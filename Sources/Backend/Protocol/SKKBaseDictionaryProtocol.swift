//
//  SKKBaseDictionaryProtocol.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

import Foundation

public protocol SKKBaseDictionaryProtocol {
    func initialize(path: String) async throws

    func find(entry: SKKEntry, to result: inout SKKCandidateSuite)
    func complete(_ helper: inout SKKCompletionHelperBridge)

    func complete(helper: inout SKKCompletionHelperProtocol)
    func reverseLookup(candidate: String) -> String
}

public extension SKKBaseDictionaryProtocol {
    public func complete(_ helper: inout SKKCompletionHelperBridge) {
        var tmp: SKKCompletionHelperProtocol = helper
        complete(helper: &tmp)
    }
}
