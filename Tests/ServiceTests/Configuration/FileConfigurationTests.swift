//
//  FileConfigurationTests.swift
//  CoreTests
//
//  Created by mzp on 8/11/24.
//

import AquaSKKService
import Testing

struct FileConfigurationTests {
    @Test func system() {
        let config = DefaultFileConfiguration()
        #expect(config.systemResourcePath == "/Library/Input Methods/AquaSKK.app/Contents/Resources")
        #expect(config.applicationSupportPath.hasSuffix("/Library/Application Support/AquaSKK"))
        #expect(config.dictionarySetPath.hasSuffix("/Library/Application Support/AquaSKK/DictionarySet.plist"))
    }
}
