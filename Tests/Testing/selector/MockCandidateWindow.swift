//
//  MockCandidateWindow.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/01.
//

import Foundation
internal import AquaSKKEngine

public class MockCandidateWindow: SKKCandidateWindowPresenter {
    public func setup(candidates: any Collection<SKKCandidate>) -> [Int] {
        return [candidates.count]
    }

    public func labelIndex(label: Character) -> Int {
        0
    }

    public func update(candidates: any Collection<SKKCandidate>, cursor: Int, position: Int, max: Int) {
    }

    public func skkWidgetShow() {}

    public func skkWidgetHide() {}


}
