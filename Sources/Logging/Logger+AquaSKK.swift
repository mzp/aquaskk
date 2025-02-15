//
//  Logger+AquaSKK.swift
//  AquaSKKLogging
//
//  Created by mzp on 2/14/25.
//

import OSLog

private let subsystem = "com.aquaskk.inputmethod"
public extension Logger {
    static let skkTesting = Logger(subsystem: subsystem, category: "Testing")
    static let skkBackend = Logger(subsystem: subsystem, category: "Backend")
    static let skkInput = Logger(subsystem: subsystem, category: "Input")
    static let skkUI = Logger(subsystem: subsystem, category: "UI")

    // MARK: Special purpose

    static let skkMemory = Logger(subsystem: subsystem, category: "MemoryDebug")

    // MARK: Compatibility

    static let testing = skkTesting
    static let backend = skkBackend
}
