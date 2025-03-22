//
//  SKKBaseDictionaryProtocol.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/21/25.
//

public protocol SKKBaseDictionaryProtocol {
    func initialize(path: String) async throws
    func find(entry: SKKEntry, to result: inout SKKCandidateSuite)
    func complete(helper: inout SKKCompletionHelperProtocol)
    func reverseLookup(candidate: String) -> String
}
