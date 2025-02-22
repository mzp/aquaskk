//
//  SKKEncodingDictionaryTests.swift
//  UITests
//
//  Created by mzp on 2/20/25.
//

import Testing
internal import AquaSKKTesting
@_spi(Testing) @testable internal import AquaSKKBackend

struct SKKTestsDataSource: SKKDictionaryDataSource {
    let okuriAri: [SKKDictionaryEntryImpl] = [
        .init(entry: "いあw", value: "/居合/"),
        .init(entry: "うけとt", value: "/受け取/受取/"),
    ]
    let okuriNasi: [SKKDictionaryEntryImpl] = [
        .init(entry: "かいはつ", value: "/開発/"),
        .init(entry: "かんじ", value: "/漢字/官寺/寛治/"),
    ]
}

struct SKKEncodingDictionaryTests {
    var dict: SKKEncodingDictionary
    init() {
        dict = SKKEncodingDictionary(encoding: .utf8)
        dict.dataSource = SKKTestsDataSource()
    }

    @Test func findOkuriNasi() {
        dict.dataSource = SKKTestsDataSource()
        #expect(dict.findOkuriNasi(query: "かんじ") == "/漢字/官寺/寛治/")
    }

    @Test func findOkuriAri() {
        dict.dataSource = SKKTestsDataSource()
        #expect(dict.findOkuriAri(query: "うけとt") == "/受け取/受取/")
    }

    @Test func reverseLookup() {
        #expect(dict.reverseLookup(candidate: "官寺") == "かんじ")
    }

    @Test func completion() {
        let mock = MockCompletionHelper.newInstance()
        mock.Initialize("かん")
        var helper: SKKCompletionHelperProtocol = mock
        dict.complete(helper: &helper)

        let candidates = Array(mock.Result())
        #expect(candidates == ["かんじ"])
    }
}
