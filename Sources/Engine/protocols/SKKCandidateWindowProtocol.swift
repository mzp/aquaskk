//
//  SKKCandidateWindowProtocol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/24.
//

@objc public protocol SKKCandidateWindowProtocol: SKKWidgetProtocol {
    @objc func setup(candidates: [String]) -> [Int]
    @objc func update(candidates: [String], cursor: Int, position: Int, max: Int)

    @objc func labelIndex(of label: Int) -> Int
}
