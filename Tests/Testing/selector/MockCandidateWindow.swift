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

    public func labelIndex(label _: Character) -> Int {
        0
    }

    public func update(candidates _: any Collection<SKKCandidate>, cursor _: Int, position _: Int, max _: Int) {}

    public func skkWidgetShow() {}

    public func skkWidgetHide() {}
}
