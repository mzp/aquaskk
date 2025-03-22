//
//  SKKInlineSelector.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//

class SKKInlineSelectorImpl {
    private var range: [SKKCandidate] = []
    private var pos: Int = 0

    func setup(container: [SKKCandidate], inlineCount: Int) {
        range = Array(container.prefix(inlineCount))
        pos = 0
    }

    func next() -> Bool {
        if isEmpty || pos == maxPosition() {
            return false
        }
        pos += 1
        return true
    }

    func prev() -> Bool {
        if isEmpty || pos == minPosition() {
            return false
        }
        pos -= 1
        return true
    }

    var current: SKKCandidate? {
        guard !isEmpty else {
            return nil
        }
        return range[pos]
    }

    var isEmpty: Bool {
        return range.isEmpty
    }

    func minPosition() -> Int {
        return 0
    }

    func maxPosition() -> Int {
        return range.count - 1
    }
}
