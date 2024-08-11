//
//  PreferenceStorageTests.swift
//  AquaSKKServiceTests
//
//  Created by mzp on 8/3/24.
//

@testable import AquaSKKService
import Testing

private let abcLayout = "com.apple.keylayout.ABC"
private let dvorakLayout = "com.apple.keylayout.Dvorak"

struct PreferenceStorageTests {
    @Test func availableKeyboardLayouts() {
        let controller = PreferenceStorage()
        let layouts = controller.availableKeyboardLayouts
        #expect(!layouts.isEmpty)

        let dvorak = layouts.first(where: {
            $0.localizedName == "Dvorak"
        })
        #expect(dvorak != nil)
        #expect(dvorak?.inputSourceID == dvorakLayout)

        let sorted = layouts.sorted(by: {
            $0.localizedName < $1.localizedName
        })
        #expect(layouts[0] == sorted[0])
    }

    @Test func readWritePreference() {
        let storage = PreferenceStorage()
        let originalLayout = storage.keyboardLayout
        defer { storage.keyboardLayout = originalLayout }
        storage.keyboardLayout = dvorakLayout
        #expect(storage.keyboardLayout == dvorakLayout)
        #expect(PreferenceStorage().keyboardLayout == dvorakLayout)
    }

    @Test func userDefaultsCompatibility() {
        let storage = PreferenceStorage()
        let originalLayout = storage.keyboardLayout
        defer { storage.keyboardLayout = originalLayout }

        PreferenceStorage().keyboardLayout = dvorakLayout
        let fromUserDefaults = UserDefaults.standard.string(forKey: "keyboard_layout")
        #expect(fromUserDefaults == dvorakLayout)

        UserDefaults.standard.setValue(abcLayout, forKey: "keyboard_layout")
        #expect(PreferenceStorage().keyboardLayout == abcLayout)
    }

    @Test func subRules() {
        let storage = PreferenceStorage()
        #expect(!storage.availableSystemSubRules.isEmpty)
        #expect(storage.availableUserSubRules.isEmpty)
    }

    @Test func setEnableRule() {
        let storage = PreferenceStorage()
        storage.subRules = []

        let rule = storage.availableSystemSubRules.first!
        #expect(rule.enabled == false)

        storage.set(rule: rule, enabled: true)
        #expect(storage.subRules == [rule.path])
        #expect(storage.subKeymaps == [rule.keymap!])

        let enabledRule = storage.availableSystemSubRules.first!
        #expect(enabledRule.enabled == true)

        storage.set(rule: rule, enabled: false)
        #expect(storage.subRules == [])
    }
}