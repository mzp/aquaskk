//
//  SKKCommonDictionaryTests.swift
//  BackendTests
//
//  Created by mzp on 2/21/25.
//

import Testing
@testable internal import AquaSKKBackend
internal import AquaSKKTesting

struct SKKCommonDictionaryTests {
    func dict(path: String, encoding: String.Encoding) async throws -> SKKDictionaryReloadAdapter {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path(path, writable: false)
        let dict = SKKDictionaryReloadAdapter(
            baseDictionary: SKKEncodingDictionary(encoding: encoding),
            source: SKKLocalDictionaryFileSource()
        )
        try await dict.initialize(path: path)
        return dict
    }

    @Test("encoding", arguments: [
        ("SKK-JISYO.TEST.UTF8", String.Encoding.utf8),
        ("SKK-JISYO.TEST", String.Encoding.japaneseEUC),
    ])
    func okuriAri(path: String, encoding: String.Encoding) async throws {
        let dict = try await dict(path: path, encoding: encoding)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("よi", "い"), to: &suite)
        #expect(suite.ToString(false) == "/良/好/酔/善/")
    }

    @Test("encoding", arguments: [
        ("SKK-JISYO.TEST.UTF8", String.Encoding.utf8),
        ("SKK-JISYO.TEST", String.Encoding.japaneseEUC),
    ])
    func okuriNasi(path: String, encoding: String.Encoding) async throws {
        let dict = try await dict(path: path, encoding: encoding)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("かんじ", ""), to: &suite)
        #expect(suite.ToString(false) == "/漢字/寛治/官寺/")
    }

    @Test("encoding", arguments: [
        ("SKK-JISYO.TEST.UTF8", String.Encoding.utf8),
        ("SKK-JISYO.TEST", String.Encoding.japaneseEUC),
    ])
    func notFound(path: String, encoding: String.Encoding) async throws {
        let dict = try await dict(path: path, encoding: encoding)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("NOT_EXIST", "d"), to: &suite)
        #expect(suite.IsEmpty() == true)
    }

    @Test("encoding", arguments: [
        ("SKK-JISYO.TEST.UTF8", String.Encoding.utf8),
        ("SKK-JISYO.TEST", String.Encoding.japaneseEUC),
    ])
    func reverseLookup(path: String, encoding: String.Encoding) async throws {
        let dict = try await dict(path: path, encoding: encoding)
        #expect(dict.reverseLookup(candidate: "漢字") == "かんじ")
    }

    @Test("encoding", arguments: [
        ("SKK-JISYO.TEST.UTF8", String.Encoding.utf8),
        ("SKK-JISYO.TEST", String.Encoding.japaneseEUC),
    ])
    func completion(path: String, encoding: String.Encoding) async throws {
        let dict = try await dict(path: path, encoding: encoding)
        let mock = MockCompletionHelper.newInstance()
        mock.Initialize("かん")
        var helper: SKKCompletionHelperProtocol = mock
        dict.complete(helper: &helper)

        let candidates = Array(mock.Result())
        #expect(candidates == ["かんじ"])
    }
}
