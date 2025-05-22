//
//  SKKCandidateSuiteTests.swift
//  BackendTests
//
//  Created by mzp on 2025/05/15.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKCandidateSuiteTests {
    @Test func add() async throws {
        var suite = SKKCandidateSuite()
        suite.add(candidate: SKKCandidate("候補", true))

        var cand = SKKCandidateContainer()
        cand.push_back(SKKCandidate("ヒント1", true))
        cand.push_back(SKKCandidate("ヒント2", true))
        suite.add(hint: SKKOkuriHint(okuri: "おくり", candidates: Array(cand)))

        #expect(suite.string(excludeAvoidStudy: false) == "/候補/[おくり/ヒント1/ヒント2/]/")

        var tmp = SKKCandidateSuite()
        tmp.add(suite: suite)

        #expect(tmp.string(excludeAvoidStudy: false) == "/候補/[おくり/ヒント1/ヒント2/]/")
    }

    @Test func update() {
        var suite = SKKCandidateSuite()
        suite.add(candidate: SKKCandidate("候補1", true))
        suite.add(candidate: SKKCandidate("候補2", true))

        var cand = SKKCandidateContainer()
        cand.push_back(SKKCandidate("候補1", true))
        cand.push_back(SKKCandidate("候補2", true))

        var hint = SKKOkuriHint(
            okuri: "おくり",
            candidates: Array(cand)
        )

        suite.add(hint: SKKOkuriHint(okuri: "おくり", candidates: Array(cand)))

        suite.update(candidate: SKKCandidate("候補2;アノテーション", true))

        #expect(suite.string() == "/候補2;アノテーション/候補1/[おくり/候補1/候補2/]/")
        cand.clear()
        cand.push_back(SKKCandidate("候補1;アノテーション", true))

        suite.update(hint: SKKOkuriHint(okuri: "おくり", candidates: Array(cand)))
        #expect(suite.string() == "/候補1;アノテーション/候補2;アノテーション/[おくり/候補1;アノテーション/候補2/]/")
    }

    @Test func findOkuriStrictly() throws {
        var suite = SKKCandidateSuite()
        suite.parse(string: "/合;(一致) 話が合う/当/[て/当/]/[って/合;(一致) 話が合う/]/")
        let strict = try #require(suite.findOkuriStrictly(okuri: "て"))
        #expect(strict.string() == "/当/")
    }

    @Test func parse() {
        let key = SKKCandidate("当", true)
        var suite = SKKCandidateSuite()
        suite.parse(string: "/合;(一致) 話が合う/当/[て/当/]/[って/合;(一致) 話が合う/]/")
        suite.remove(candidate: key)
        #expect(suite.string() == "/合;(一致) 話が合う/[って/合;(一致) 話が合う/]/")

        suite.add(candidate: SKKCandidate("(skk-ignore-dic-word \"test\")", true))

        #expect(suite.string() == "/合;(一致) 話が合う/(skk-ignore-dic-word \"test\")/[って/合;(一致) 話が合う/]/")
    }
}
