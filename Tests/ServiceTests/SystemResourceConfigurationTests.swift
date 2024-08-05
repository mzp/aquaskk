//
//  SystemResourceConfigurationTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AquaSKKService
import Testing

struct SystemResourceConfigurationTests {
    @Test func systemResource() {
        let config = SKSSystemResourceConfiguration()

        let keymap = config.path(forSystemResource: "keymap.conf")
        #expect(keymap == "/Library/Input Methods/AquaSKK.app/Contents/Resources/keymap.conf")

        let kanaRule = config.path(forSystemResource: "kana-rule.conf")
        #expect(kanaRule == "/Library/Input Methods/AquaSKK.app/Contents/Resources/kana-rule.conf")
    }
}
