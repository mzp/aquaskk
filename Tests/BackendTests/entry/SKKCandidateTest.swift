//
//  SKKCandidateTest.swift
//  BackendTests
//
//  Created by mzp on 2025/05/12.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKCandidateTest {
    @Test func empty() {
        let c = SKKCandidate()
        #expect(c.IsEmpty())
        #expect(c.ToString() == "")
    }

    @Test func annotatedWord() {
        let c = SKKCandidate("候補;アノテーション", true)
        #expect(c.IsEmpty() == false)
        #expect(c.word == "候補")
        #expect(c.annotation == "アノテーション")
        #expect(c.ToString() == "候補;アノテーション")
    }

    @Test func variant() {
        var c1 = SKKCandidate("候補", true)
        let c2 = SKKCandidate("候補", true)

        c1.SetVariant("数値変換")
        #expect(c1.variant == "数値変換")
        #expect(c1 != c2)
    }

    @Test func encode() {
        #expect(SKKCandidate.Encode("[/;") == "[5b][2f][3b]")
        #expect(SKKCandidate.Decode("[5b][2f][3b]") == "[/;")
    }
}
