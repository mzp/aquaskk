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
    let backend: SKKBackendImpl = .init()

    init() async throws {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        let jisyoPath = try resource.path("skk-jisyo.utf8", writable: false)
        let testJisyoPath = try resource.path("SKK-JISYO.TEST", writable: false)

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
        #expect(suite.isEmpty)

        suite.clear()
        backend.find(entry: SKKEntry("よi", "い"), to: &suite)
        #expect(suite.string() == "/良/好/酔/善/")

        suite.clear()
        backend.find(entry: SKKEntry("たんごとうろく", ""), to: &suite)
        #expect(suite.string() == "/単語登録/")

        // skk-ignore-dic-word 対応
        suite.clear()
        backend.find(entry: SKKEntry("おおk", "き"), to: &suite)
        #expect(suite.string() == "/大/")

        suite.clear()
        backend.find(entry: SKKEntry("むし", ""), to: &suite)
        #expect(suite.string() == "/蒸し/虫/")
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
        #expect(String(suite.string()) == "/有/[り/有/]/")
        suite.clear()

        backend.find(entry: SKKEntry("かなめ", ""), to: &suite)
        #expect(suite.string() == "/要/")
        suite.clear()

        // 削除
        backend.remove(entry: SKKEntry("あr", "り"), candidate: SKKCandidate("有", true))
        backend.remove(entry: SKKEntry("かなめ", ""), candidate: SKKCandidate("要", true))

        result = backend.complete(key: "か", limit: 0)
        #expect(result[0] != "かなめ")

        backend.find(entry: SKKEntry("あk", "り"), to: &suite)
        #expect(suite.isEmpty)
        suite.clear()

        backend.find(entry: SKKEntry("かなめ", ""), to: &suite)
        #expect(suite.isEmpty)
    }

    @Test func reverseLookup() {
        #expect(backend.reverseLookup(candidate: "漢字") == "かんじ")
    }
}
