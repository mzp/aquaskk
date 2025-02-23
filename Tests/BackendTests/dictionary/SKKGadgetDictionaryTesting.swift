//
//  SKKGadgetDictionaryTesting.swift
//  UITests
//
//  Created by mzp on 2/16/25.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKGadgetDictionaryTesting {
    @Test func main() {
        let dict = SKKGadgetDictionaryImpl()
        dict.initialize(path: ".")
        var suite = SKKCandidateSuite()
        dict.find(entry: .init("today", ""), to: &suite)
        dict.find(entry: .init("now", ""), to: &suite)
        dict.find(entry: .init("=(32768+64)*1024", ""), to: &suite)
    }

    @Test func today() throws {
        let dict = SKKGadgetDictionaryImpl()
        dict.initialize(path: ".")
        var suite = SKKCandidateSuite()
        dict.find(entry: .init("today", ""), to: &suite)
        #expect(suite.candidates.count == 2)
    }

    @Test func now() throws {
        let dict = SKKGadgetDictionaryImpl()
        dict.initialize(path: ".")
        var suite = SKKCandidateSuite()
        dict.find(entry: .init("now", ""), to: &suite)
        #expect(suite.candidates.count == 2)
    }

    @Test func clac() throws {
        let dict = SKKGadgetDictionaryImpl()
        dict.initialize(path: ".")
        var suite = SKKCandidateSuite()
        dict.find(entry: .init("=3*2", ""), to: &suite)
        let candidate = try #require(suite.candidates.first)
        #expect(candidate.word == "6")
    }
}
