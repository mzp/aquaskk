//
//  SandboxTests.swift
//  AquaSKK-PreferencesTests
//
//  Created by mzp on 7/31/24.
//

import AquaSKKService
@testable import PreferenceApp
import Testing

struct SandboxTests {
    @Test func preferenceShouldBeWritable() throws {
        let config = DefaultServerConfiguration()
        #expect(!config.userDefaultsPath.contains("Library/Containers/"))
        let url = URL(fileURLWithPath: "\(config.userDefaultsPath)")
        try Data().write(to: url)
    }
}
