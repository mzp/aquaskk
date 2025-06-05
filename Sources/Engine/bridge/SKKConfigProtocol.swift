//
//  SKKConfigProtocol.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/24.
//

import Foundation

@objc public protocol SKKConfigProtocol {
    @objc func fixIntermediateConversion() -> Bool
    @objc func enableDynamicCompletion() -> Bool

    @objc func dynamicCompletionRange() -> Int

    @objc func enableAnnotation() -> Bool
    @objc func displayShortestMatchOfKanaConversions() -> Bool

    @objc func suppressNewlineOnCommit() -> Bool
    @objc func maxCountOfInlineCandidates() -> Int

    @objc func handleRecursiveEntryAsOkuri() -> Bool

    @objc func inlineBackSpaceImpliesCommit() -> Bool
    @objc func deleteOkuriWhenQuit() -> Bool
}
