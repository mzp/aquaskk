//
//  PreferenceStoreTests.swift
//  AquaSKKServiceTests
//
//  Created by mzp on 8/3/24.
//

import AquaSKKService
import AquaSKKTesting
import Testing

private let abcLayout = "com.apple.keylayout.ABC"
private let dvorakLayout = "com.apple.keylayout.Dvorak"

struct PreferenceStoreTests {
    func createStore() throws -> PreferenceStore {
        let bundle = ServiceTesting.shared.bundle
        let configuration = try BundledServerConfiguration(bundle: bundle)
        return PreferenceStore(serverConfiguration: configuration)
    }

    init() {
        guard let name = Bundle.main.bundleIdentifier else {
            return
        }
        let userDefaults = UserDefaults.standard
        guard let dictionary = userDefaults.persistentDomain(forName: name) else {
            return
        }
        for key in dictionary.keys {
            userDefaults.removeObject(forKey: key)
        }
    }

    @Test func availableKeyboardLayouts() throws {
        let store = try createStore()
        let layouts = store.availableKeyboardLayouts
        #expect(!layouts.isEmpty)

        let dvorak = try #require(layouts.first(where: {
            $0.localizedName == "Dvorak"
        }))
        #expect(dvorak.inputSourceID == dvorakLayout)

        let sorted = layouts.sorted(by: {
            $0.localizedName < $1.localizedName
        })
        #expect(layouts == sorted)
    }

    @Test func persist() throws {
        let bundle = ServiceTesting.shared.bundle
        let configuration = try BundledServerConfiguration(bundle: bundle)
        let store = PreferenceStore(serverConfiguration: configuration)
        store.keyboardLayout = dvorakLayout
        store.flush()

        let url = URL(fileURLWithPath: configuration.userDefaultsPath)
        let dictionary = try #require(NSDictionary(contentsOf: url))
        let layout = try #require(dictionary["keyboard_layout"] as? String)
        #expect(layout == dvorakLayout)
    }

    @Test func readWritePreference() throws {
        // default value
        let store = try createStore()
        #expect(store.keyboardLayout == "com.apple.keylayout.US")

        // store -> user defaults
        store.keyboardLayout = dvorakLayout

        #expect(store.keyboardLayout == dvorakLayout)

        let fromUserDefaults = UserDefaults.standard.string(forKey: "keyboard_layout")
        #expect(fromUserDefaults == dvorakLayout)

        let fromOtherClass = try createStore().keyboardLayout
        #expect(fromOtherClass == dvorakLayout)

        // user deafults -> store
        // UserDefaults.standard.setValue(abcLayout, forKey: "keyboard_layout")
        //
        // let fromStore = try createStore().keyboardLayout
        // #expect(fromStore == abcLayout)
    }

    @Test func subRules() throws {
        let store = try createStore()
        #expect(!store.availableSystemSubRules.isEmpty)
        #expect(store.availableUserSubRules.isEmpty)
    }

    @Test func setEnableRule() throws {
        let store = try createStore()
        store.subRules = []

        let rule = store.availableSystemSubRules.first!
        #expect(rule.enabled == false)

        store.set(rule: rule, enabled: true)
        #expect(store.subRules == [rule.path])
        #expect(store.subKeymaps == [rule.keymap!])

        let enabledRule = store.availableSystemSubRules.first!
        #expect(enabledRule.enabled == true)

        store.set(rule: rule, enabled: false)
        #expect(store.subRules == [])
    }
}
