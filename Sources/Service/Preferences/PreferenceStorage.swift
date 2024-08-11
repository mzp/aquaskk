//
//  PreferenceStorage.swift
//  AquaSKKService
//
//  Created by mzp on 8/6/24.
//

import Combine
import Foundation
import SwiftUI

/// AquaSKK の設定を管理する。
public class PreferenceStorage: ObservableObject {
    private let configuration: FileConfiguration

    public static let `default` = PreferenceStorage(configuration: DefaultFileConfiguration())

    public init(configuration: FileConfiguration) {
        self.configuration = configuration
        jisyoController = JisyoController(path: configuration.dictionarySetPath)
    }

    // デフォルト値はUserDefaults.plistに格納されておりSKKServerが初期化するので、
    // ここでは適当な初期値を与える
    // FIXME: Load from UserDefaults.plist/embedded the default value

    // MARK: - Text edit setting

    @AppStorage("suppress_newline_on_commit") public var suppressNewlineOnCommit: Bool = false
    @AppStorage("use_numeric_conversion") public var useNumericConversion: Bool = false
    @AppStorage("show_input_mode_icon") public var showInputModeIcon: Bool = false
    @AppStorage("use_individual_input_mode") public var useIndividualInputMode: Bool = false
    @AppStorage("beep_on_registration") public var beepOnRegistration: Bool = false

    // MARK: - Keyboard layout

    /// 利用可能なキーボードを取得する。
    public var availableKeyboardLayouts: [KeyboardLayout] {
        // 検索条件(ASCII 入力可能なキーボードレイアウト)
        let conditions = [
            kTISPropertyInputSourceType: kTISTypeKeyboardLayout as Any,
            kTISPropertyInputSourceIsASCIICapable: kCFBooleanTrue as Any,
        ]
        // リストして名前でソートする
        guard let array = TISCreateInputSourceList(conditions as CFDictionary, true).takeUnretainedValue() as? [TISInputSource] else {
            return []
        }
        return array.map { KeyboardLayout(tisInputSourceRef: $0) }
            .sorted(by: { $0.localizedName < $1.localizedName })
    }

    /// キーボード配列。
    ///
    /// - Note: Store in input source id.
    @AppStorage("keyboard_layout") public var keyboardLayout: String = "com.apple.keylayout.ABC"

    // MARK: - Sub rules

    public var subRules: [String] {
        get {
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: "sub_rules") as? [String]
            return array ?? []
        }
        set {
            objectWillChange.send()
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "sub_rules")
        }
    }

    public var subKeymaps: [String] {
        get {
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: "sub_keymaps") as? [String]
            return array ?? []
        }
        set {
            objectWillChange.send()
            let defaults = UserDefaults.standard
            defaults.setValue(newValue, forKey: "sub_keymaps")
        }
    }

    public var availableSystemSubRules: [SubRule] {
        let controller = SubRuleController(path: configuration.systemResourcePath, activeRules: subRules)
        return controller.allRules
    }

    public var availableUserSubRules: [SubRule] {
        let controller = SubRuleController(path: configuration.applicationSupportPath, activeRules: subRules)
        return controller.allRules
    }

    public func set(rule: SubRule, enabled: Bool) {
        var subRules = Set(self.subRules)
        var subKeymaps = Set(self.subKeymaps)
        if enabled {
            subRules.insert(rule.path)

            if let path = rule.keymap {
                subKeymaps.insert(path)
            }
        } else {
            subRules.remove(rule.path)

            if let path = rule.keymap {
                subKeymaps.remove(path)
            }
        }
        self.subRules = Array(subRules)
        self.subKeymaps = Array(subKeymaps)
    }

    // MARK: - Jisyo(SKK Dictionary)

    @AppStorage("user_dictionary_path") public var userJisyoPath: String = ""

    private let jisyoController: JisyoController
    public var systemJisyos: [Jisyo] {
        jisyoController.allJisyo
    }

    public func set(jisyo: Jisyo, enabled: Bool) {
        objectWillChange.send()
        jisyoController.set(jisyo: jisyo, enabled: enabled)
    }

    public func set(jisyo: Jisyo, type: Int) {
        objectWillChange.send()
        if let jisyoType = JisyoType(rawValue: type) {
            jisyoController.set(jisyo: jisyo, type: jisyoType)
        }
    }

    public func set(jisyo: Jisyo, location: String) {
        objectWillChange.send()
        jisyoController.set(jisyo: jisyo, location: location)
    }

    // MARK: - Completion

    @AppStorage("enable_extended_completion") public var enableExtendedCompletion: Bool = false
    // min:0 - max:15
    @AppStorage("minimum_completion_length") public var minimumCompletionLength: Int = 0

    @AppStorage("enable_dynamic_completion") public var enableDynamicCompletion: Bool = false

    /// min 1 - max: 100
    @AppStorage("dynamic_completion_range") public var dynamicCompletionRange: Int = 1

    // MARK: - Candidate

    // 0 - 100
    @AppStorage("max_count_of_inline_candidates") public var maxCountOfInlineCandidates: Int = 1
    @AppStorage("candidate_window_labels") public var candidateWindowLabels: String = ""
    @AppStorage("candidate_window_font_name") public var candidateWindowFontName: String = ""
    @AppStorage("candidate_window_font_size") public var candidateWindowFontSize: Int = 0
    @AppStorage("put_candidate_window_upward") public var putCandidateWindowUpward: Bool = false
    @AppStorage("enable_annotation") public var enableAnnotation: Bool = false

    // MARK: - skkserve

    @AppStorage("enable_skkserv") public var enableSkkserv: Bool = false
    @AppStorage("skkserv_localonly") public var skkservLocalonly: Bool = false
    @AppStorage("skkserv_port") public var skkservPort: Int = 0

    // MARK: - Other

    @AppStorage("display_shortest_match_of_kana_conversions") public var displayShortestMatchOfKanaConversions: Bool = false
    @AppStorage("handle_recursive_entry_as_okuri") public var handleRecursiveEntryAsOkuri: Bool = false
    @AppStorage("delete_okuri_when_quit") public var deleteOkuriWhenQuit: Bool = false
    @AppStorage("inline_backspace_implies_commit") public var inlineBackspaceImpliesCommit: Bool = false

    // MARK: - Internal preference

    @AppStorage("enable_private_mode") public var enablePrivateMode: Bool?
    @AppStorage("fix_intermediate_conversion") public var fixIntermediateConversion: Bool?
    @AppStorage("openlab_host") public var openlabHost: String?
    @AppStorage("openlab_path") public var openlabPath: String?
    @AppStorage("enable_skkdap") public var enableSkkdap: Bool?
    @AppStorage("skkdap_folder") public var skkdapFolder: String?
    @AppStorage("skkdap_port") public var skkdapPort: Int = 0

    // TODO: DECLARE_NSStringKey(direct_clients);
}
