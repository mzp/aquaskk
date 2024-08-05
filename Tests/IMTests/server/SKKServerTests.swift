//
//  SKKServerTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AquaSKKIM_Private
import Testing

struct SKKServerTests {
    @Test func componentFiles() async throws {
        let server = SKKServer()

        let keymap = server.path(forResource: "keymap.conf")

        #expect(keymap == "/Library/Input Methods/AquaSKK.app/Contents/Resources/keymap.conf")
        let kanaRule = server.path(forResource: "kana-rule.conf")
        #expect(kanaRule == "/Library/Input Methods/AquaSKK.app/Contents/Resources/kana-rule.conf")
    }
}
