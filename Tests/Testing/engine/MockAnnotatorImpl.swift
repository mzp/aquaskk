//
//  MockAnnotatorImpl 2.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//

internal import AquaSKKEngine
internal import AquaSKKBackend

class MockAnnotatorImpl: MockWidget, SKKAnnotatorProtocol {
    var candidate: String?
    var cursorOffset: Int = 0

    func update(candidateBridge bridge: SKKCandidateBridge, cursorOffset: Int) {
        candidate = String(bridge.rawValue.pointee.ToString())
        self.cursorOffset = cursorOffset
    }
}
