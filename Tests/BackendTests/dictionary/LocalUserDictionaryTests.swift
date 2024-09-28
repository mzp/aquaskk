//
//  LocalUserDictionaryTests.swift
//  BackendTests
//
//  Created by mzp on 9/15/24.
//

internal import AquaSKKTesting
import Testing
@testable internal import AquaSKKBackend

class BackendBundle {}

struct LocalUserDictionaryTests {
    let dict: LocalUserDictionary
    init() async throws {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("skk-jisyo.utf8", writable: true)
        dict = LocalUserDictionary()
        try await dict.initialize(path: path)
    }

    @Test func notFound() {
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("#", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }

    @Test func okuriAri() {
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送り有/")
    }

    @Test func okuriNasi() {
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("かんじ", ""), to: &suite)
        #expect(suite.ToString() == "/漢字/")
    }

    @Test func registerOkuriNasi() throws {
        let result = dict.register(entry: SKKEntry("かんり", ""), candidate: SKKCandidate("管理", true))
        #expect(result == true)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("かんり", ""), to: &suite)
        #expect(suite.ToString() == "/管理/")

        dict.remove(entry: SKKEntry("かんり", ""), candidate: SKKCandidate("管理", true))

        suite.Clear()
        dict.find(entry: SKKEntry("かんり", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }

    @Test func registerOkuriAri() throws {
        let result = dict.register(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))
        #expect(result == true)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送りあ/[り/送りあ/]/")

        dict.remove(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))

        suite.Clear()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送り有/")
    }

    @Test func helper() {
        let result = dict.register(entry: SKKEntry("かんり", ""), candidate: SKKCandidate("管理", true))
        #expect(result == true)

        let mock = MockCompletionHelper.newInstance()
        mock.Initialize("かん")
        var helper: CompletionHelper = mock
        dict.complete(helper: &helper)

        let candidates = mock.Result()
        #expect(candidates[0] == "かんり")
        #expect(candidates[1] == "かんじ")
    }

    @Test func helperNotFound() throws {
        var mock = MockCompletionHelper.newInstance()
        mock.Initialize("かんり")

        var helper: CompletionHelper = mock
        dict.complete(helper: &helper)

        let candidates = mock.Result()
        #expect(candidates.isEmpty == true)
    }

    @Test func privateMode() async throws {
        dict.setPrivateMode(value: true)

        let result = dict.register(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))
        #expect(result == true)

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送りあ/[り/送りあ/]/")

        dict.setPrivateMode(value: false)

        suite.Clear()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送り有/")
    }

    @Test(arguments: [
        ("漢字", "かんじ"),
        ("管理", ""),
    ]) func reverseLookup(candidate: String, entry: String) {
        let result = dict.reverseLookup(candidate: candidate)
        #expect(entry == result)
    }

    @Test func completion() {
        dict.remove(entry: SKKEntry("ほかん1", ""), candidate: SKKCandidate("", true))
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("ほかん1", ""), to: &suite)
        #expect(suite.ToString() == "/補完1/")
    }

    @Test func toggleCompletion() throws {
        let result = dict.register(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate("", true))
        #expect(result == true)
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("とぐるほかん", ""), to: &suite)
        #expect(suite.IsEmpty() == true)

        dict.remove(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate("", true))
        dict.find(entry: SKKEntry("とぐるほかん", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }

    @Test func comment() throws {
        let result = dict.register(entry: SKKEntry("encode", ""), candidate: SKKCandidate("abc;def", true))
        #expect(result == true)
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("encode", ""), to: &suite)
        #expect(suite.ToString() == "/abc;def/")

        dict.remove(entry: SKKEntry("encode", ""), candidate: SKKCandidate("abc;def", true))
        suite.Clear()
        dict.find(entry: SKKEntry("encode", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }
}
