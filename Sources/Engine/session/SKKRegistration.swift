//
//  SKKRegistration.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

import Foundation

public struct SKKRegistrationImpl {
    public var word: String
    public var state: SKKRegistrationState

    public init() {
        word = ""
        state = .None
    }

    mutating public func start() {
        state = .Started
    }

    mutating public func finish(string: String) {
        state = .Finished
        word = string
    }

    public mutating func abort() {
        state = .Aborted
        word = ""
    }

    public mutating func clear () {
        state = .None
        word = ""
    }

    // MARK: - Bridge

    public func bridgedWord() -> String {
        word
    }

    public func bridgedState() -> SKKRegistrationState {
        state
    }
}
