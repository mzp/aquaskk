//
//  DefaultServerConfigurationTests.swift
//  AppTests
//
//  Created by mzp on 8/14/24.
//

import AquaSKKService
import Testing

struct DefaultServerConfigurationTests {
    @Test func resourcePath() {
        let config = DefaultServerConfiguration()

        let path = config.systemPath(forName: "keymap.conf")
        #expect(path == "/Library/Input Methods/AquaSKK.app/Contents/Resources/keymap.conf")
    }

    @Test func userPath() {
        let config = DefaultServerConfiguration()
        let path = config.userPath(forName: "kana-rule.conf")
        #expect(path.hasSuffix("Library/Application Support/AquaSKK/kana-rule.conf"))
    }
}
