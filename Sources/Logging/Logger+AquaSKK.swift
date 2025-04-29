//
//  Logger+AquaSKK.swift
//  AquaSKKLogging
//
//  Created by mzp on 2/14/25.
//

import OSLog

private let subsystem = "com.aquaskk.inputmethod"
public extension Logger {
    // MARK: - For Backend

    static let skkBackend = Logger(subsystem: "\(subsystem).backend", category: "Default")

    // MARK: - For InputMethod

    static let skkInput = Logger(subsystem: "\(subsystem).input", category: "Default")
    static let skkMemory = Logger(subsystem: "\(subsystem).input", category: "Memory")
    static let skkIMK = Logger(subsystem: "\(subsystem).input", category: "InputMethodKit")

    // MARK: - UI

    static let skkUI = Logger(subsystem: "\(subsystem).ui", category: "Default")

    // MARK: - Engine

    static let skkEngine = Logger(subsystem: "\(subsystem).engine", category: "Default")
    static let skkState = Logger(subsystem: "\(subsystem).engine", category: "StateMachine")

    // MARK: - For Testing

    static let skkTesting = Logger(subsystem: "\(subsystem).testing", category: "Testing")
    static let skkTyper = Logger(subsystem: "\(subsystem).testing", category: "Typer")

    // MARK: Compatibility

    static let testing = skkTesting
    static let backend = skkBackend
}
