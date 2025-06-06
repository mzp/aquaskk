//
//  MockAnnotatorImpl 2.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//

internal import AquaSKKEngine
internal import AquaSKKBackend

class MockAnnotatorImpl: MockWidget, SKKAnnotatorProtocol {
    var candidateBridge: SKKCandidateBridge?
    var candidate: SKKCandidate? {
        candidateBridge?.rawValue.pointee
    }

    var cursorOffset: Int = 0

    func update(candidateBridge bridge: SKKCandidateBridge, cursorOffset: Int) {
        candidateBridge = bridge
        self.cursorOffset = cursorOffset
    }
}
