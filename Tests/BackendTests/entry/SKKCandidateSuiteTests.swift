//
//  SKKCandidateSuiteTests.swift
//  BackendTests
//
//  Created by mzp on 2025/05/15.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKCandidateSuiteTesting {
    @Test func add() async throws {
        var suite = SKKCandidateSuite()
        suite.Add(SKKCandidate("候補", true))

        var cand = SKKCandidateContainer()
        cand.push_back(SKKCandidate("ヒント1", true))
        cand.push_back(SKKCandidate("ヒント2", true))
        suite.Add(SKKOkuriHint(first: "おくり", second: cand))

        #expect(suite.ToString(false) == "/候補/[おくり/ヒント1/ヒント2/]/")

        var tmp = SKKCandidateSuite()
        tmp.Add(suite)

        #expect(tmp.ToString(false) == "/候補/[おくり/ヒント1/ヒント2/]/")
    }

    @Test func update() {
        var suite = SKKCandidateSuite()
        suite.Add(SKKCandidate("候補1", true))
        suite.Add(SKKCandidate("候補2", true))

        var cand = SKKCandidateContainer()
        cand.push_back(SKKCandidate("候補1", true))
        cand.push_back(SKKCandidate("候補2", true))

        var hint = newSKKOkuriHint()
        hint.first = "おくり"
        hint.second = cand

        suite.Add(SKKOkuriHint(first: "おくり", second: cand))

        suite.Update(SKKCandidate("候補2;アノテーション", true))

        #expect(suite.ToString(false) == "/候補2;アノテーション/候補1/[おくり/候補1/候補2/]/")
        cand.clear()
        cand.push_back(SKKCandidate("候補1;アノテーション", true))

        suite.Update(SKKOkuriHint(first: "おくり", second: cand))
        #expect(suite.ToString(false) == "/候補1;アノテーション/候補2;アノテーション/[おくり/候補1;アノテーション/候補2/]/")
    }

    @Test func remove() {
        let key = SKKCandidate("当", true)
        var suite = SKKCandidateSuite()
        suite.Parse("/合;(一致) 話が合う/当/[て/当/]/[って/合;(一致) 話が合う/]/")
        suite.Remove(key)
        #expect(suite.ToString(false) == "/合;(一致) 話が合う/[って/合;(一致) 話が合う/]/")

        suite.Add(SKKCandidate("(skk-ignore-dic-word \"test\")", true))

        #expect(suite.ToString(false) == "/合;(一致) 話が合う/(skk-ignore-dic-word \"test\")/[って/合;(一致) 話が合う/]/")
    }
}
