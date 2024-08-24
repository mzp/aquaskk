//
//  AquaSKK_PreferencesTests.swift
//  AquaSKK-PreferencesTests
//
//  Created by mzp on 7/31/24.
//

@testable import PreferenceApp
import Testing
import AquaSKKService

struct SandboxTests {
    @Test func preferenceShouldBeWritable() throws {
        let config = DefaultServerConfiguration()
        #expect(!config.userDefaultsPath.contains("Library/Containers/"))
        let url = URL(fileURLWithPath: "\(config.userDefaultsPath)")
        NSLog("\(config.userDefaultsPath)")
        try Data().write(to: url)
    }
}
