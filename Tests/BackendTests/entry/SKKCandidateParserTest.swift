//
//  SKKCandidateParserTest.swift
//  BackendTests
//
//  Created by mzp on 2025/05/12.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKCandidateParserTest {
    // MARK: - Candidate

    @Test func emptyCandiadte() {
        let parser = SKKCandidateParser()
        parser.parse("//")
        #expect(parser.candidates.isEmpty)
        #expect(parser.hints.isEmpty)
    }

    @Test func single() throws {
        let parser = SKKCandidateParser()
        parser.parse("/候補1/")
        #expect(parser.candidates.count == 1)
        let candidate = try #require(parser.candidates.first)
        #expect(candidate == SKKCandidate("候補1", true))
    }

    @Test func annotation() {
        let parser = SKKCandidateParser()
        parser.parse("/候補1/候補2;アノテーション/候補3/")
        #expect(parser.candidates.count == 3)

        if parser.candidates.count == 3 {
            #expect(parser.candidates[0] == SKKCandidate("候補1", true))
            #expect(parser.candidates[1] == SKKCandidate("候補2", true))
            #expect(parser.candidates[1].annotation == "アノテーション")
            #expect(parser.candidates[2] == SKKCandidate("候補3", true))
        }
    }

    @Test func bracketInAnnotation() {
        let parser = SKKCandidateParser()
        parser.parse("/候補;[]][アノテーション/")

        #expect(parser.candidates.count == 1)
        #expect(parser.hints.isEmpty)
    }

    // MARK: - Okuri Hint

    @Test func okuriHint() throws {
        let parser = SKKCandidateParser()
        parser.parse("/候補1/[おくり/候補1/]/")

        #expect(parser.candidates.count == 1)
        #expect(parser.hints.count == 1)

        let hint = try #require(parser.hints.first)
        #expect(hint.first == "おくり")
        #expect(hint.second.count == 1)
        #expect(try #require(hint.second.first) == SKKCandidate("候補1", true))
    }

    @Test func emptyHint() throws {
        let parser = SKKCandidateParser()
        parser.parse("//[]/[///]/[おくり/候補1/候補2/]//")
        #expect(parser.candidates.isEmpty)

        #expect(parser.hints.count == 1)

        let hint = try #require(parser.hints.first)

        #expect(hint.second.count == 2)
        let candidate = try #require(hint.second.first)
        #expect(candidate == SKKCandidate("候補1", true))
    }
}
