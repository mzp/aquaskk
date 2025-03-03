//
//  SKKCandidateWindowPresenter.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//
import Foundation

public protocol SKKCandidatePresenter {
    func setup(candidates: [String]) -> [Int]
    func labelIndex(of: Int) -> Int
    func update(candidates: [String], cursor: Int, position: Int, max: Int)
    func show()
    func hide()
}
