//
//  SKKBackendTesting.swift
//  UITests
//
//  Created by mzp on 2025/02/23.
//

import Testing
internal import AquaSKKTesting
import AquaSKKService
@testable internal import AquaSKKBackend

struct SKKBackendTesting {
    let backend = SKKBackend.shared()

    init() async throws {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        let jisyoPath = try resource.path("skk-jisyo.utf8", writable: true)
        let testJisyoPath = try resource.path("SKK-JISYO.TEST", writable: true)

        await backend.initialize(path: jisyoPath, configurations: [
            .init(type: .common, location: testJisyoPath),
            .init(type: .common, location: testJisyoPath),
        ])
    }

    @Test func complete() {
        let result = backend.complete(key: "か", limit: 0)
        #expect(result.first == "かんじ")
    }

    @Test func find() {
        var suite = SKKCandidateSuite()
        backend.find(entry: SKKEntry("NOT-EXIST", "え"), to: &suite)
        #expect(suite.IsEmpty())

        suite.Clear()
        backend.find(entry: SKKEntry("よi", "い"), to: &suite)
        #expect(suite.ToString(false) == "/良/好/酔/善/")

        suite.Clear()
        backend.find(entry: SKKEntry("たんごとうろく", ""), to: &suite)
        #expect(suite.ToString(false) == "/単語登録/")

        // skk-ignore-dic-word 対応
        suite.Clear()
        backend.find(entry: SKKEntry("おおk", "き"), to: &suite)
        #expect(suite.ToString(false) == "/大/")

        suite.Clear()
        backend.find(entry: SKKEntry("むし", ""), to: &suite)
        #expect(suite.ToString(false) == "/蒸し/虫/")
    }

    @Test func register() {
        // 登録
        backend.register(entry: SKKEntry("あr", "り"), candidate: SKKCandidate("有", true))
        backend.register(entry: SKKEntry("かなめ", ""), candidate: SKKCandidate("要", true))

        // 補完
        var result = backend.complete(key: "か", limit: 0)
        #expect(result[0] == "かなめ")
        #expect(result[1] == "かんじ")

        // 検索
        var suite = SKKCandidateSuite()
        backend.find(entry: SKKEntry("あr", "り"), to: &suite)
        #expect(String(suite.ToString(false)) == "/有/[り/有/]/")
        suite.Clear()

        backend.find(entry: SKKEntry("かなめ", ""), to: &suite)
        #expect(suite.ToString(false) == "/要/")
        suite.Clear()

        // 削除
        backend.remove(entry: SKKEntry("あr", "り"), candidate: SKKCandidate("有", true))
        backend.remove(entry: SKKEntry("かなめ", ""), candidate: SKKCandidate("要", true))

        result = backend.complete(key: "か", limit: 0)
        #expect(result[0] != "かなめ")

        backend.find(entry: SKKEntry("あk", "り"), to: &suite)
        #expect(suite.IsEmpty())
        suite.Clear()

        backend.find(entry: SKKEntry("かなめ", ""), to: &suite)
        #expect(suite.IsEmpty())
    }

    @Test func reverseLookup() {
        #expect(backend.reverseLookup(candidate: "漢字") == "かんじ")
    }
}
