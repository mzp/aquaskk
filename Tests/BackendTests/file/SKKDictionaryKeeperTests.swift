//
//  SKKDictionaryKeeperTests.swift
//  UITests
//
//  Created by mzp on 2/20/25.
//

import Testing
internal import AquaSKKTesting
@testable internal import AquaSKKBackend

struct SKKDictionaryKeeperTestsDataSource: SKKDictionaryDataSource {
    let okuriAri: [SKKDictionaryEntryImpl] = [
        .init(entry: "いあw", value: "/居合/"),
        .init(entry: "うけとt", value: "/受け取/受取/"),
    ]
    let okuriNasi: [SKKDictionaryEntryImpl] = [
        .init(entry: "かいはつ", value: "/開発/"),
        .init(entry: "かんじ", value: "/漢字/官寺/寛治/"),
    ]
}

struct SKKDictionaryKeeperTests {
    var keeper: SKKDictionaryReader
    init() {
        self.keeper = SKKDictionaryReader(encoding: .utf8)
        keeper.dataSource = SKKDictionaryKeeperTestsDataSource()
    }

    @Test func findOkuriNasi() {
        keeper.dataSource = SKKDictionaryKeeperTestsDataSource()
        #expect(keeper.findOkuriNasi(query: "かんじ") == "/漢字/官寺/寛治/")
    }

    @Test func findOkuriAri() {
        keeper.dataSource = SKKDictionaryKeeperTestsDataSource()
        #expect(keeper.findOkuriAri(query: "うけとt") == "/受け取/受取/")
    }

    @Test func reverseLookup() {
        #expect(keeper.reverseLookup(candidate: "官寺") == "かんじ")
    }

    @Test func completion() {
        let mock = MockCompletionHelper.newInstance()
        mock.Initialize("かん")
        var helper: SKKCompletionHelperProtocol = mock
        keeper.complete(helper: &helper)

        let candidates = Array(mock.Result())
        #expect(candidates == ["かんじ"])
    }
}
