//
//  MacConfig.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/24.
//

import AquaSKKEngine
import Foundation

@objc public class MacConfigImpl: NSObject, SKKConfigProtocol {
    public func fixIntermediateConversion() -> Bool {
        return boolConfig(SKKUserDefaultKeys.fix_intermediate_conversion)
    }

    public func enableDynamicCompletion() -> Bool {
        return boolConfig(SKKUserDefaultKeys.enable_dynamic_completion)
    }

    public func dynamicCompletionRange() -> Int {
        return integerConfig(SKKUserDefaultKeys.dynamic_completion_range)
    }

    public func enableAnnotation() -> Bool {
        return boolConfig(SKKUserDefaultKeys.enable_annotation)
    }

    public func displayShortestMatchOfKanaConversions() -> Bool {
        return boolConfig(SKKUserDefaultKeys.display_shortest_match_of_kana_conversions)
    }

    public func suppressNewlineOnCommit() -> Bool {
        return boolConfig(SKKUserDefaultKeys.suppress_newline_on_commit)
    }

    public func maxCountOfInlineCandidates() -> Int {
        return integerConfig(SKKUserDefaultKeys.max_count_of_inline_candidates)
    }

    public func handleRecursiveEntryAsOkuri() -> Bool {
        return boolConfig(SKKUserDefaultKeys.handle_recursive_entry_as_okuri)
    }

    public func inlineBackSpaceImpliesCommit() -> Bool {
        return boolConfig(SKKUserDefaultKeys.inline_backspace_implies_commit)
    }

    public func deleteOkuriWhenQuit() -> Bool {
        return boolConfig(SKKUserDefaultKeys.delete_okuri_when_quit)
    }

    // private methods

    private func integerConfig(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    private func boolConfig(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
