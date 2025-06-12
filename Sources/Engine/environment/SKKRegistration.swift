//
//  SKKRegistration.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

@objc public class SKKRegistrationImpl: NSObject {
    public var word: String
    public var state: SKKRegistrationState

    @objc override public init() {
        word = ""
        state = .None
        super.init()
    }

    @objc public func start() {
        state = .Started
    }

    @objc public func finish(string: String) {
        state = .Finished
        word = string
    }

    @objc public func abort() {
        state = .Aborted
        word = ""
    }

    @objc public func clear() {
        state = .None
        word = ""
    }

    // MARK: - Bridge

    public func bridgedWord() -> String {
        word
    }

    public func bridgedState() -> Int32 {
        state.rawValue
    }
}
