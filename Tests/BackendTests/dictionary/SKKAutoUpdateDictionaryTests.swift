//
//  SKKAutoUpdateDictionaryTests.swift
//  UITests
//
//  Created by mzp on 2/21/25.
//

import Testing
@_spi(Testing) @testable internal import AquaSKKBackend

struct SKKAutoUpdateDictionaryTests {
    @Test func test() async throws {
        let dict = SKKAutoUpdateDictionary()
        try await dict.initialize(path: "raw.githubusercontent.com /skk-dev/dict/refs/heads/master/SKK-JISYO.S SKK-JISYO.S1")
        try await dict.refresh()
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("dummy", "d"), to: &suite)
        #expect(suite.isEmpty == true)
        #expect(FileManager.default.fileExists(atPath: "SKK-JISYO.S1") == true)
        #expect(dict.reverseLookup(candidate: "逆") == "ぎゃく")
    }
}
