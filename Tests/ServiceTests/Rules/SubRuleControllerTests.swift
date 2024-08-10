//
//  SubRuleControllerTests.swift
//  CoreTests
//
//  Created by mzp on 8/8/24.
//

import AquaSKKService
import Testing

struct SubRuleControllerTests {
    @Test func array() async throws {
        let controller = SubRuleController(
            path: TestingContent.resourcePath,
            activeRules: [
                TestingContent.bundle.path(forResource: "azik", ofType: "rule")!,
            ]
        )
        let rules = controller.allRules
        #expect(controller.allRules.count == 2)

        let azik = rules[0]
        #expect(azik.enabled == true)
        #expect(azik.name == "azik.rule")
        #expect(azik.keymap == "azik.conf")
        #expect(azik.description != "")

        let period = rules[1]
        #expect(period.enabled == false)
        #expect(period.name == "period.rule")
        #expect(period.keymap == nil)
        #expect(period.description != "")
    }
}
