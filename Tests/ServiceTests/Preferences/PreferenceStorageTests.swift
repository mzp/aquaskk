//
//  PreferenceStorageTests.swift
//  AquaSKKServiceTests
//
//  Created by mzp on 8/3/24.
//

@testable import AquaSKKService
import AquaSKKTesting
import Testing

private let abcLayout = "com.apple.keylayout.ABC"
private let dvorakLayout = "com.apple.keylayout.Dvorak"

struct PreferenceStorageTests {
    func preferenceStorage() throws -> PreferenceStorage {
        let bundle = ServiceTesting.shared.bundle
        let configuration = try BundledServerConfiguration(bundle: bundle)
        return PreferenceStorage(configuration: configuration)
    }

    init() {
        let userDefaults = UserDefaults.standard
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }
    }

    @Test func availableKeyboardLayouts() throws {
        let controller = try preferenceStorage()
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

    @Test func readWritePreference() throws {
        let storage = try preferenceStorage()
        storage.keyboardLayout = dvorakLayout

        #expect(storage.keyboardLayout == dvorakLayout)

        let fromUserDefaults = UserDefaults.standard.string(forKey: "keyboard_layout")
        #expect(fromUserDefaults == dvorakLayout)

        let fromOtherClass = try preferenceStorage().keyboardLayout
        #expect(fromOtherClass == dvorakLayout)

        UserDefaults.standard.setValue(abcLayout, forKey: "keyboard_layout")
        let fromStorage = try preferenceStorage().keyboardLayout

        #expect(fromStorage == abcLayout)
    }

    @Test func subRules() throws {
        let storage = try preferenceStorage()
        #expect(!storage.availableSystemSubRules.isEmpty)
        #expect(storage.availableUserSubRules.isEmpty)
    }

    @Test func setEnableRule() throws {
        let storage = try preferenceStorage()
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
