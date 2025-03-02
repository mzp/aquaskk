//
//  SKKWindowSelectorTesting.swift
//  BackendTests
//
//  Created by mzp on 2025/03/01.
//

import Testing
internal import AquaSKKBackend
@testable internal import AquaSKKEngine

class NullCandidateWindow: SKKCandidateWindowPresenter {
    func show() {}

    func hide() {}

    func setup(candidates: [String]) -> [Int] {
        return [candidates.count]
    }

    func labelIndex(of _: Int) -> Int {
        0
    }

    func update(candidates _: [String], cursor _: Int, position _: Int, max _: Int) {}
}

struct SKKWindowSelectorTesting {
    @Test func main() throws {
        var container: [SKKCandidate] = []
        let testWindow = NullCandidateWindow()
        let selector = SKKWindowSelectorImpl(presenter: testWindow)

        container.append(SKKCandidate("候補1", true))
        container.append(SKKCandidate("候補2", true))
        container.append(SKKCandidate("候補3", true))
        container.append(SKKCandidate("候補4", true))
        container.append(SKKCandidate("候補5", true))
        container.append(SKKCandidate("候補6", true))

        selector.setup(container: container, inlineCount: 3)

        #expect(!selector.isEmpty)
        #expect(!selector.prev())
        #expect(try String(#require(selector.current).variant) == "候補4")

        selector.cursorRight()
        selector.cursorRight()

        #expect(try String(#require(selector.current).variant) == "候補6")
    }
}
