//
//  MockConfigImpl.swift
//  AquaSKKTesting
//
//  Created by mzp on 2025/06/06.
//

import Foundation

internal import AquaSKKEngine

public class MockConfigImpl: SKKConfigProtocol {
    var fixIntermediateConversionValue: Bool = true
    public func fixIntermediateConversion() -> Bool {
        fixIntermediateConversionValue
    }

    public func setFixIntermediateConversion(_ value: Bool) {
        fixIntermediateConversionValue = value
    }

    var enableDynamicCompletionValue: Bool = true
    public func enableDynamicCompletion() -> Bool {
        enableDynamicCompletionValue
    }

    public func setEnableDynamicCompletion(_ value: Bool) {
        enableDynamicCompletionValue = value
    }

    var dynamicCompletionRangeValue = 1
    public func dynamicCompletionRange() -> Int {
        dynamicCompletionRangeValue
    }

    public func setDynamicCompletionRange(_ value: Int) {
        dynamicCompletionRangeValue = value
    }

    var enableAnnotationValue = true
    public func enableAnnotation() -> Bool {
        enableAnnotationValue
    }

    func setEnableAnnotation(_ value: Bool) {
        enableAnnotationValue = value
    }

    var displayShortestMatchOfKanaConversionsValue = false
    public func displayShortestMatchOfKanaConversions() -> Bool {
        displayShortestMatchOfKanaConversionsValue
    }

    public func setDisplayShortestMatchOfKanaConversions(_ value: Bool) {
        displayShortestMatchOfKanaConversionsValue = value
    }

    var suppressNewlineOnCommitValue: Bool = true
    public func suppressNewlineOnCommit() -> Bool {
        suppressNewlineOnCommitValue
    }

    public func setSuppressNewlineOnCommit(_ value: Bool) {
        suppressNewlineOnCommitValue = value
    }

    var maxCountOfInlineCandidatesValue: Int = 5
    public func maxCountOfInlineCandidates() -> Int {
        maxCountOfInlineCandidatesValue
    }

    public func setMaxCountOfInlineCandidates(_ value: Int) {
        maxCountOfInlineCandidatesValue = value
    }

    var handleRecursiveEntryAsOkuriValue = false
    public func handleRecursiveEntryAsOkuri() -> Bool {
        handleRecursiveEntryAsOkuriValue
    }

    public func setHandleRecursiveEntryAsOkuri(_ value: Bool) {
        handleRecursiveEntryAsOkuriValue = value
    }

    var inlineBackSpaceImpliesCommitValue: Bool = false
    public func inlineBackSpaceImpliesCommit() -> Bool {
        inlineBackSpaceImpliesCommitValue
    }

    public func setInlineBackSpaceImpliesCommit(_ value: Bool) {
        inlineBackSpaceImpliesCommitValue = value
    }

    var deleteOkuriWhenQuitValue = true
    public func deleteOkuriWhenQuit() -> Bool {
        deleteOkuriWhenQuitValue
    }

    public func setDeleteOkuriWhenQuit(_ value: Bool) {
        deleteOkuriWhenQuitValue = value
    }

    public static func defaults(
        annotation: Bool = true,
        dynamicCompletion: Bool = true,
        suppressNewlineOnCommit: Bool = true,
        inlineBackSpaceImpliesCommit: Bool = false,
        handleRecursiveEntryAsOkuri: Bool = false
    ) -> MockConfigImpl {
        let config = MockConfigImpl()
        config.setEnableAnnotation(annotation)
        config.setEnableDynamicCompletion(dynamicCompletion)
        config.setSuppressNewlineOnCommit(suppressNewlineOnCommit)
        config.setInlineBackSpaceImpliesCommit(inlineBackSpaceImpliesCommit)
        config.setHandleRecursiveEntryAsOkuri(handleRecursiveEntryAsOkuri)
        return config
    }
}
