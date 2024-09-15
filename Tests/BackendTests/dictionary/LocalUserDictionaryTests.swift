//
//  LocalUserDictionaryTests.swift
//  BackendTests
//
//  Created by mzp on 9/15/24.
//

import Testing
import AquaSKKTesting
@testable internal import AquaSKKBackend

class BackendBundle {}

struct LocalUserDictionaryTests {
    let dict: LocalUserDictionary
    init() throws {
        let bundle = Bundle(for: BackendBundle.self)
        let path = try #require(bundle.path(forResource: "skk-jisyo", ofType: "utf8"))

        self.dict = LocalUserDictionary()
        dict.initialize(path: path)
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

    @Test func registerOkuriNasi() {
        dict.register(entry: SKKEntry("かんり", ""), candidate: SKKCandidate("管理", true))

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("かんり", ""), to: &suite)
        #expect(suite.ToString() == "/管理/")

        dict.remove(entry: SKKEntry("かんり", ""), candidate: SKKCandidate("管理", true))


        suite.Clear()
        dict.find(entry: SKKEntry("かんり", ""), to: &suite)
        #expect(suite.ToString() == "/管理/")
    }

    @Test func registerOkuriAri() {
        dict.register(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送りあ/[り/送りあ/]/")

        dict.remove(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))

        suite.Clear()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送り有/")
    }

    @Test func helper() {
        var helper = MockCompletionHelper()
        helper.Initialize("かん")
//        dict.complete(helper: helper)
/*        MockCompletionHelper helper;
        helper.Initialize("かん");
        dict.Complete(helper);
        XCTAssert(helper.Result()[0] == "かんり" && helper.Result()[1] == "かんじ");*/

        /*
         helper.Initialize("かんり");
         dict.Complete(helper);
         XCTAssert(helper.Result().empty());
         */
    }

    @Test func privateMode() {
        dict.privateMode = true

        dict.register(entry: SKKEntry("おくりあr", "り"), candidate: SKKCandidate("送りあ", true))

        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送りあ/[り/送りあ/]/")

        dict.privateMode = false

        suite.Clear();
        dict.find(entry: SKKEntry("おくりあr", "り"), to: &suite)
        #expect(suite.ToString() == "/送り有/")
    }

    @Test func reverseLookup() {
        let entry = dict.reverseLookup(candidate: "漢字")
        #expect(entry == "かんじ")
    }

    @Test func completion() {
        dict.remove(entry: SKKEntry("ほかん1", ""), candidate: SKKCandidate("", true))
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("ほかん1", ""), to: &suite)
        #expect(suite.ToString() == "/補完1/")
    }

    @Test func toggleCompletion() {
        dict.register(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate("", true))
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("とぐるほかん", ""), to: &suite)
        #expect(suite.IsEmpty() == true)

        dict.remove(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate("", true))
        dict.find(entry: SKKEntry("とぐるほかん", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }

    @Test func comment() {
        dict.register(entry: SKKEntry("encode", ""), candidate: SKKCandidate("abc;def", true))
        var suite: SKKCandidateSuite = .init()
        dict.find(entry: SKKEntry("encode", ""), to: &suite)
        #expect(suite.ToString() == "abc;def")

        dict.remove(entry: SKKEntry("encode", ""), candidate: SKKCandidate("abc;def", true))
        suite.Clear()
        dict.find(entry: SKKEntry("encode", ""), to: &suite)
        #expect(suite.IsEmpty() == true)
    }
}
