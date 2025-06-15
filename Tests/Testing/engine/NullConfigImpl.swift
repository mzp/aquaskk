//
//  NullConfigImpl.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/06.
//
import AquaSKKEngine

class NullConfigImpl: SKKConfigProtocol {
    func fixIntermediateConversion() -> Bool {
        true
    }

    func enableDynamicCompletion() -> Bool {
        true
    }

    func dynamicCompletionRange() -> Int {
        0
    }

    func enableAnnotation() -> Bool {
        false
    }

    func displayShortestMatchOfKanaConversions() -> Bool {
        false
    }

    func suppressNewlineOnCommit() -> Bool {
        true
    }

    func maxCountOfInlineCandidates() -> Int {
        5
    }

    func handleRecursiveEntryAsOkuri() -> Bool {
        false
    }

    func inlineBackSpaceImpliesCommit() -> Bool {
        false
    }

    func deleteOkuriWhenQuit() -> Bool {
        true
    }
}
