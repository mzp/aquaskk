//
//  SKKWindowSelectorTesting.swift
//  BackendTests
//
//  Created by mzp on 2025/03/01.
//

import Testing
internal import AquaSKKBackend
@testable internal import AquaSKKEngine

class NullCandidateWindow: CandidateWindowPresenter {
    func setup(candidates: some Collection<SKKCandidate>) -> [Int] {
        return [candidates.count]
    }

    func labelIndex(label: Character) -> Int {
        0
    }

    func update(candidates: some Collection<SKKCandidate>, cursor: Int, position: Int, max: Int) {
    }

    
    func show() {

    }
    
    func hide() {

    }
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
        #expect(String(try #require(selector.current).variant) == "候補4")

        selector.cursorRight()
        selector.cursorRight()

        #expect(String(try #require(selector.current).variant) == "候補6")
    }
}
