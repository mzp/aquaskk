//
//  SandboxedTests.swift
//  AppTests
//
//  Created by mzp on 8/24/24.
//
import AquaSKKService
import Testing

struct SandboxedTests {
    @Test func sandboxed() {
        let config = DefaultServerConfiguration()
        NSLog(config.userDefaultsPath)
        #expect(!config.userDefaultsPath.contains("Library/Containers/"))
    }
}
