//
//  SKKUserDictionaryProtocol.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/22.
//

public protocol SKKUserDictionaryProtocol {
    func register(entry: SKKEntry, candidate: SKKCandidate) -> Bool
    func remove(entry: SKKEntry, candidate: SKKCandidate)
    func setPrivateMode(value: Bool)
}
