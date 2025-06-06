//
//  MockCandidateWindowImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//
internal import AquaSKKEngine

class MockCandidateWindowImpl: MockWidget, SKKCandidateWindowProtocol {
    var candidates = [String]()
    var cursor: Int = 0
    var position: Int = 0
    func setup(candidates: [String]) -> [Int] {
        self.candidates = candidates

        return [candidates.count]
    }

    func update(candidates _: [String], cursor: Int, position: Int, max _: Int) {
        self.cursor = cursor
        self.position = position
    }

    func labelIndex(of label: Int) -> Int {
        return label - Int(Character("a").asciiValue!)
    }
}
