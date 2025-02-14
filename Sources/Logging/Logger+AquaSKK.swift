//
//  Logger+AquaSKK.swift
//  AquaSKKLogging
//
//  Created by mzp on 2/14/25.
//

import OSLog

private let subsystem = "com.aquaskk.inputmethod"
extension Logger {
    public static let skkTesting = Logger(subsystem: subsystem, category: "Testing")
    public static let skkBackend = Logger(subsystem: subsystem, category: "Backend")
    public static let skkInput = Logger(subsystem: subsystem, category: "Input")
    public static let skkUI = Logger(subsystem: subsystem, category: "UI")

    public static let testing = skkTesting
    public static let backend = skkBackend
}
