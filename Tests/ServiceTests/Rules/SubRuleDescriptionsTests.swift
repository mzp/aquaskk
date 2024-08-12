//
//  SubRuleDescriptionsTests.swift
//  ServiceTests
//
//  Created by mzp on 8/8/24.
//
import AquaSKKService
import Foundation
import Testing

struct SubRuleDescriptionsTests {
    func subRuleDescriptions() -> SubRuleDescriptions {
        let path = ServiceTesting.shared.resourcePath
        return SubRuleDescriptions(path)
    }

    @Test func keymap() async throws {
        var rule = subRuleDescriptions()
        #expect(rule.HasKeymap("azik.rule") == true)
        #expect(rule.Keymap("azik.rule") == "azik.conf")
        #expect(rule.Description("azik.rule") == "拡張ローマ字入力「AZIK」を使う(JIS配列用)")
    }

    @Test func conf() {
        var rule = subRuleDescriptions()
        #expect(rule.HasKeymap("period.rule") == false)
        #expect(rule.Keymap("period.rule") == "")
        #expect(rule.Description("period.rule") == "句点をピリオド(．)にする")
    }
}
