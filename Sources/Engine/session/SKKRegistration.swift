//
//  SKKRegistration.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

import Foundation

public struct SKKRegistrationImpl {
    public private(set) var word: String
    public private(set) var state: SKKRegistrationState

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
}
/*public:
    SKKRegistration()
        : state_(SKKRegistrationState::None) {}

    void Start() {
        state_ = SKKRegistrationState::Started;
    }

    void Finish(const std::string &str) {
        state_ = SKKRegistrationState::Finished;
        word_ = str;
    }

    void Abort() {
        state_ = SKKRegistrationState::Aborted;
        word_.clear();
    }

    void Clear() {
        state_ = SKKRegistrationState::None;
        word_.clear();
    }

    operator SKKRegistrationState() const {
        return state_;
    }

    const SKKRegistrationState getState() const SWIFT_COMPUTED_PROPERTY {
        return state_;
    }
    const std::string getWord() const SWIFT_COMPUTED_PROPERTY {
        return word_;
    }

    const std::string &Word() const {
        return word_;
    }

private:
    SKKRegistrationState state_;
    std::string word_;
};
*/
