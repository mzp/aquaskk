//
//  SystemResourceConfigurationTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AquaSKKService
import Testing

struct SystemResourceConfigurationTests {
    let config = AISSystemResourceConfiguration()

    @Test func conf() {
        let keymap = config.path(forSystemResource: "keymap.conf")
        #expect(keymap == "/Library/Input Methods/AquaSKK.app/Contents/Resources/keymap.conf")

        let kanaRule = config.path(forSystemResource: "kana-rule.conf")
        #expect(kanaRule == "/Library/Input Methods/AquaSKK.app/Contents/Resources/kana-rule.conf")
    }

    @Test func plist() {
        let userDefaults = config.path(forSystemResource: "UserDefaults.plist")
        #expect(userDefaults == "/Library/Input Methods/AquaSKK.app/Contents/Resources/UserDefaults.plist")

        let dictionarySet = config.path(forSystemResource: "DictionarySet.plist")
        #expect(dictionarySet == "/Library/Input Methods/AquaSKK.app/Contents/Resources/DictionarySet.plist")

        let blacklist = config.path(forSystemResource: "BlacklistApps.plist")
        #expect(blacklist == "/Library/Input Methods/AquaSKK.app/Contents/Resources/BlacklistApps.plist")
    }
}
