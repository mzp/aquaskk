//
//  Logger+Testing.swift
//  AquaSKKTesting
//
//  Created by mzp on 8/23/24.
//

import Foundation
import OSLog

extension Logger {
    static let testing = Logger(subsystem: "com.aquaskk.inputmethod", category: "Testing")
}
