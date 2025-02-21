//
//  SKKDictionaryKeeperTests.swift
//  UITests
//
//  Created by mzp on 2/20/25.
//

import Testing
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
    @Test func findOkuriNasi() {
        let keeper = SKKDictionaryKeeper(encoding: .utf8)
        keeper.dataSource = SKKDictionaryKeeperTestsDataSource()
        #expect(keeper.findOkuriNasi(query: "かんじ") == "/漢字/官寺/寛治/")
    }

    @Test func findOkuriAri() {
        let keeper = SKKDictionaryKeeper(encoding: .utf8)
        keeper.dataSource = SKKDictionaryKeeperTestsDataSource()
        #expect(keeper.findOkuriAri(query: "うけとt") == "/受け取/受取/")
    }

}
