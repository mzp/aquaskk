//
//  DefaultServerConfigurationTests.swift
//  AppTests
//
//  Created by mzp on 8/14/24.
//

import AquaSKKService
import Testing

struct DefaultServerConfigurationTests {
    let config = DefaultServerConfiguration()
    @Test func resourcePath() {
        let path = config.systemPath(forName: "keymap.conf")
        #expect(path == "/Library/Input Methods/AquaSKK.app/Contents/Resources/keymap.conf")
    }

    @Test func userPath() {
        let path = config.userPath(forName: "kana-rule.conf")
        #expect(path.hasSuffix("Library/Application Support/AquaSKK/kana-rule.conf"))
    }

    @Test func system() {
        #expect(config.systemResourcePath == "/Library/Input Methods/AquaSKK.app/Contents/Resources")
        #expect(config.applicationSupportPath.hasSuffix("/Library/Application Support/AquaSKK"))
        #expect(config.dictionarySetPath.hasSuffix("/Library/Application Support/AquaSKK/DictionarySet.plist"))
    }
}
