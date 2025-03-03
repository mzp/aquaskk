//
//  SKKInlnlineSelectorTesting.swift
//  BackendTests
//
//  Created by mzp on 2025/03/01.
//

import Testing
@testable internal import AquaSKKEngine

struct SKKInlnlineSelectorTesting {
    @Test func main() throws {
        var container: [SKKCandidate] = []
        container.append(SKKCandidate("候補1", true))
        container.append(SKKCandidate("候補2", true))
        container.append(SKKCandidate("候補3", true))
        let selector = SKKInlineSelectorImpl()
        selector.setup(container: container, inlineCount: 3)
        #expect(selector.isEmpty == false)

        #expect(selector.prev() == false)
        #expect(try #require(selector.current).variant == "候補1")

        #expect(selector.next() == true)
        #expect(try #require(selector.current).variant == "候補2")

        #expect(selector.next() == true)
        #expect(try #require(selector.current).variant == "候補3")

        #expect(selector.next() == false)

        #expect(selector.prev() == true)
        #expect(try #require(selector.current).variant == "候補2")
    }
}
