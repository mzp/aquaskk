//
//  DictionaryKeeperTests.swift
//  UITests
//
//  Created by mzp on 10/1/24.
//

import Testing
@testable internal import AquaSKKBackend
internal import AquaSKKTesting

class MockLoader: DictionaryLoader {
    var path: String
    init(path: String) {
        self.path = path
    }
    override func needsUpdate() -> Bool {
        true
    }
    override func interval() -> TimeInterval {
        5
    }
    override func timeout() -> TimeInterval {
        5
    }
    override func filePath() -> String {
        path
    }
}
struct DictionaryKeeperTests {
    let path: String
    let keeper = DictionaryKeeper(encoding: .utf8)
    init() throws {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        path = try resource.path("SKK-JISYO.TEST")

        let loader = MockLoader(path: path)
        keeper.initialize(loader: loader)
    }

    @Test func okuriNasi() {
        let words = keeper.findOkuriNasi(query: "かんじ")
        #expect(words.contains("/官寺"))
    }

    @Test func reverseLookup() {
        let reading = keeper.reverseLookup(candidate: "官寺")
        #expect(reading == "かんじ")
    }

    @Test func completion() {
        let helper = MockCompletionHelper.newInstance()
        helper.Initialize("か");
        // keeper.complete(helper: &helper)
        let first = helper.Result().first
        #expect(first == "かんじ")
    }
}
