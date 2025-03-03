//
//  SKKCandidateWindow.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

import Foundation

class SKKCandidateWindowBridgeAdapter: SKKCandidatePresenter {
    let impl: SKKCandidateWindowBridge
    init(_ impl: SKKCandidateWindowBridge) {
        self.impl = impl
    }

    public func setup(candidates: [String]) -> [Int] {
        var container = SKKCandidateContainer()
        for candidate in candidates {
            container.push_back(SKKCandidate(std.string(candidate), true))
        }
        return impl.Setup(container).map(Int.init)
    }

    public func labelIndex(of label: Int) -> Int {
        Int(impl.LabelIndex(CChar(label)))
    }

    public func update(candidates: [String], cursor: Int, position: Int, max: Int) {
        var container = SKKCandidateContainer()
        for candidate in candidates {
            container.push_back(SKKCandidate(std.string(candidate), true))
        }
        impl.Update(container, Int32(cursor), Int32(position), Int32(max))
    }

    public func show() {
        impl.Show()
    }

    public func hide() {
        impl.Hide()
    }
}
