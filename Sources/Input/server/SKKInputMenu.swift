//
//  SKKInputMenu.swift
//  AquaSKKInput
//
//  Created by mzp on 2/2/25.
//
import AquaSKKBackend
import InputMethodKit
import os

private let kInputModeTable: [(Int, SKKInputMode, String)] = [
    (SKK_HIRAKANA_MODE, SKKInputMode.HirakanaInputMode, "com.apple.inputmethod.Japanese.Hiragana"),
    (SKK_KATAKANA_MODE, SKKInputMode.KatakanaInputMode, "com.apple.inputmethod.Japanese.Katakana"),
    (SKK_JISX0201KANA_MODE, SKKInputMode.Jisx0201KanaInputMode, "com.apple.inputmethod.Japanese.HalfWidthKana"),
    (SKK_JISX0208LATIN_MODE, SKKInputMode.Jisx0208LatinInputMode, "com.apple.inputmethod.Japanese.FullWidthRoman"),
    (SKK_ASCII_MODE, SKKInputMode.AsciiInputMode, "com.apple.inputmethod.Roman"),
    // InputSource
    (SKK_HIRAKANA_MODE, SKKInputMode.HirakanaInputMode, "jp.sourceforge.inputmethod.aquaskk.Hiragana"),
    (SKK_KATAKANA_MODE, SKKInputMode.KatakanaInputMode, "jp.sourceforge.inputmethod.aquaskk.Katakana"),
    (SKK_JISX0201KANA_MODE, SKKInputMode.Jisx0201KanaInputMode, "jp.sourceforge.inputmethod.aquaskk.HalfWidthKana"),
    (SKK_JISX0208LATIN_MODE, SKKInputMode.Jisx0208LatinInputMode, "jp.sourceforge.inputmethod.aquaskk.FullWidthRoman"),
    (SKK_ASCII_MODE, SKKInputMode.AsciiInputMode, "jp.sourceforge.inputmethod.aquaskk.Ascii"),
]

@objc(SKKInputMenu) public class SKKInputMenu: NSObject {
    @MainActor static var unifiedInputMode: SKKInputMode = .HirakanaInputMode

    private let client: IMKTextInput
    private var activated: Bool = true
    public private(set) var currentInputMode: SKKInputMode = .HirakanaInputMode

    @objc(initWithClient:) public init(with client: IMKTextInput) {
        self.client = client
        super.init()
    }

    @MainActor @objc public func updateMenu(_ mode: SKKInputMode) {
        guard let identifier = modeIdentifier(inputMode: mode) else {
            return
        }

        currentInputMode = mode
        Self.unifiedInputMode = mode
        if activated {
            Logger.skkInput.log("\(#function): selectMode(\(identifier)")
            client.selectMode(identifier)
        }
    }

    @objc public func activation() {
        Logger.skkInput.log("\(#function)")
        activated = true
    }

    @objc public func deactivation() {
        Logger.skkInput.log("\(#function)")
        activated = false
    }

    // MARK: - Lookup

    public func modeIdentifier(inputMode: SKKInputMode) -> String? {
        for (_, mode, identifier) in kInputModeTable {
            if inputMode == mode {
                return identifier
            }
        }
        return nil
    }

    func inputMode(modeIdentifier: String) -> SKKInputMode? {
        for (_, mode, identifier) in kInputModeTable {
            if identifier.caseInsensitiveCompare(modeIdentifier) == .orderedSame {
                return mode
            }
        }
        return nil
    }

    func eventId(modeIdentifier: String) -> Int {
        for (eventId, _, identifier) in kInputModeTable {
            if identifier.caseInsensitiveCompare(modeIdentifier) == .orderedSame {
                return eventId
            }
        }
        return 0
    }

    // MARK: - Objective C Shims

    @objc(currentInputMode)
    public func getCurrentInputMode() -> SKKInputMode {
        return currentInputMode
    }

    @objc(unifiedInputMode)
    @MainActor public func getUnifiedInputMode() -> SKKInputMode {
        return Self.unifiedInputMode
    }

    @objc(convertIdToInputMode:)
    public func convertIdToInputMode(modeIdentifier: String) -> SKKInputMode {
        return inputMode(modeIdentifier: modeIdentifier) ?? .InvalidInputMode
    }

    @objc(convertIdToEventId:)
    public func convertIdToEventId(modeIdentifier: String) -> Int {
        return eventId(modeIdentifier: modeIdentifier)
    }

    @objc(convertInputModeToId:)
    public func convertInputModeToId(inputMode: SKKInputMode) -> String {
        return modeIdentifier(inputMode: inputMode) ?? ""
    }
}
