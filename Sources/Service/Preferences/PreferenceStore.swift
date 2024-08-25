//
//  PreferenceStore.swift
//  AquaSKKService
//
//  Created by mzp on 8/6/24.
//

import Combine
import Foundation
import OSLog
import SwiftUI

// AquaSKK の設定を管理する。
//
// 設定は `configuration.userDefaultsPath` に保存されている。
// SKKServerはUserdefaults.standardから読み書きするので、
// 初期化時にUserdefaults.standardに転送する。
// またStandardDefaultsが変更されたら、`serverConfiguration.userDefaultsPath`に保存する。

public class PreferenceStore: ObservableObject {
    private let serverConfiguration: ServerConfiguration
    private let defaults: AISUserDefaults
    private var tokens = Set<AnyCancellable>()

    public static let `default` = PreferenceStore(serverConfiguration: DefaultServerConfiguration())

    public init(serverConfiguration: ServerConfiguration) {
        self.serverConfiguration = serverConfiguration

        defaults = AISUserDefaults(serverConfiguration: serverConfiguration)
        defaults.prepare()
        let standardDefaults = defaults.standard

        // デフォルト値は UserDefaults.standard に格納されいるので、ここでの初期値は型だけ合わせる
        _suppressNewlineOnCommit = .init(wrappedValue: false, "suppress_newline_on_commit", store: standardDefaults)
        _useNumericConversion = .init(wrappedValue: false, "use_numeric_conversion", store: standardDefaults)
        _showInputModeIcon = .init(wrappedValue: false, "show_input_mode_icon", store: standardDefaults)
        _useIndividualInputMode = .init(wrappedValue: false, "use_individual_input_mode", store: standardDefaults)
        _beepOnRegistration = .init(wrappedValue: false, "beep_on_registration", store: standardDefaults)

        _keyboardLayout = .init(wrappedValue: "", "keyboard_layout", store: standardDefaults)

        _userJisyoPath = .init(wrappedValue: "", "user_jisyo_path", store: standardDefaults)

        _enableExtendedCompletion = .init(wrappedValue: false, "enable_extended_completion", store: standardDefaults)
        _minimumCompletionLength = .init(wrappedValue: 0, "minimum_completion_length", store: standardDefaults)
        _enableDynamicCompletion = .init(wrappedValue: false, "enable_dynamic_completion", store: standardDefaults)
        _dynamicCompletionRange = .init(wrappedValue: 0, "dynamic_completion_range", store: standardDefaults)

        _maxCountOfInlineCandidates = .init(wrappedValue: 0, "max_count_of_inline_candidates", store: standardDefaults)
        _candidateWindowLabels = .init(wrappedValue: "", "candidate_window_labels", store: standardDefaults)
        _candidateWindowFontName = .init(wrappedValue: "", "candidate_window_font_name", store: standardDefaults)
        _candidateWindowFontSize = .init(wrappedValue: 0, "candidate_window_font_size", store: standardDefaults)
        _putCandidateWindowUpward = .init(wrappedValue: false, "put_candidate_window_upward", store: standardDefaults)
        _enableAnnotation = .init(wrappedValue: false, "enable_annotation", store: standardDefaults)

        _enableSkkserv = .init(wrappedValue: false, "enable_skkserv", store: standardDefaults)
        _skkservLocalonly = .init(wrappedValue: false, "skkserv_localonly", store: standardDefaults)
        _skkservPort = .init(wrappedValue: 0, "skkserv_port", store: standardDefaults)

        _displayShortestMatchOfKanaConversions = .init(wrappedValue: false, "display_shortest_match_of_kana_conversions", store: standardDefaults)
        _handleRecursiveEntryAsOkuri = .init(wrappedValue: false, "handle_recursive_entry_as_okuri", store: standardDefaults)
        _deleteOkuriWhenQuit = .init(wrappedValue: false, "delete_okuri_when_quit", store: standardDefaults)
        _inlineBackspaceImpliesCommit = .init(wrappedValue: false, "inline_backspace_implies_commit", store: standardDefaults)

        _enablePrivateMode = .init(wrappedValue: false, "enable_private_mode", store: standardDefaults)
        _fixIntermediateConversion = .init(wrappedValue: false, "fix_intermediate_conversion", store: standardDefaults)
        _openlabHost = .init(wrappedValue: "", "openlab_host", store: standardDefaults)
        _openlabPath = .init(wrappedValue: "", "openlab_path", store: standardDefaults)
        _enableSkkdap = .init(wrappedValue: false, "enable_skkdap", store: standardDefaults)
        _skkdapFolder = .init(wrappedValue: "", "skkdap_folder", store: standardDefaults)
        _skkdapPort = .init(wrappedValue: 0, "skkdap_port", store: standardDefaults)

        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.flush()
            }.store(in: &tokens)
    }

    deinit {
        flush()
    }

    public func flush() {
        defaults.saveChanges()
    }

    // MARK: - Text edit setting

    @AppStorage public var suppressNewlineOnCommit: Bool
    @AppStorage public var useNumericConversion: Bool
    @AppStorage public var showInputModeIcon: Bool
    @AppStorage public var useIndividualInputMode: Bool
    @AppStorage public var beepOnRegistration: Bool

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
    @AppStorage public var keyboardLayout: String

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
        let controller = SubRuleController(path: serverConfiguration.systemResourcePath, activeRules: subRules)
        return controller.allRules
    }

    public var availableUserSubRules: [SubRule] {
        let controller = SubRuleController(path: serverConfiguration.applicationSupportPath, activeRules: subRules)
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

    @AppStorage public var userJisyoPath: String

    private lazy var jisyoController: JisyoController = .init(path: serverConfiguration.dictionarySetPath)

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

    @AppStorage public var enableExtendedCompletion: Bool // [0, 15]
    @AppStorage public var minimumCompletionLength: Int
    @AppStorage public var enableDynamicCompletion: Bool
    @AppStorage public var dynamicCompletionRange: Int // [1, 100]

    // MARK: - Candidate

    @AppStorage public var maxCountOfInlineCandidates: Int // [0, 100]
    @AppStorage public var candidateWindowLabels: String
    @AppStorage public var candidateWindowFontName: String
    @AppStorage public var candidateWindowFontSize: Int
    @AppStorage public var putCandidateWindowUpward: Bool
    @AppStorage public var enableAnnotation: Bool

    // MARK: - skkserve

    @AppStorage public var enableSkkserv: Bool
    @AppStorage public var skkservLocalonly: Bool
    @AppStorage public var skkservPort: Int

    // MARK: - Other

    @AppStorage public var displayShortestMatchOfKanaConversions: Bool
    @AppStorage public var handleRecursiveEntryAsOkuri: Bool
    @AppStorage public var deleteOkuriWhenQuit: Bool
    @AppStorage public var inlineBackspaceImpliesCommit: Bool

    // MARK: - Internal preference

    @AppStorage public var enablePrivateMode: Bool
    @AppStorage public var fixIntermediateConversion: Bool
    @AppStorage public var openlabHost: String
    @AppStorage public var openlabPath: String
    @AppStorage public var enableSkkdap: Bool
    @AppStorage public var skkdapFolder: String
    @AppStorage public var skkdapPort: Int

    // TODO: DECLARE_NSStringKey(direct_clients);
}
