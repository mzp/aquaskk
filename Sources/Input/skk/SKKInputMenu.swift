//
//  SKKInputMenu.swift
//  AquaSKKInput
//
//  Created by mzp on 2/2/25.
//
import AquaSKKBackend
import AquaSKKEngine
import InputMethodKit
import os

private let kInputModeTable: [(Int, SKKInputMode, String)] = [
    (Int(SKKEventID.hirakanaMode.rawValue), SKKInputMode.HirakanaInputMode, "com.apple.inputmethod.Japanese.Hiragana"),
    (Int(SKKEventID.katakanaMode.rawValue), SKKInputMode.KatakanaInputMode, "com.apple.inputmethod.Japanese.Katakana"),
    (Int(SKKEventID.jisx0201KanaMode.rawValue), SKKInputMode.Jisx0201KanaInputMode, "com.apple.inputmethod.Japanese.HalfWidthKana"),
    (Int(SKKEventID.jisx0208LatinMode.rawValue), SKKInputMode.Jisx0208LatinInputMode, "com.apple.inputmethod.Japanese.FullWidthRoman"),
    (Int(SKKEventID.asciiMode.rawValue), SKKInputMode.AsciiInputMode, "com.apple.inputmethod.Roman"),
    // InputSource
    (Int(SKKEventID.hirakanaMode.rawValue), SKKInputMode.HirakanaInputMode, "jp.sourceforge.inputmethod.aquaskk.Hiragana"),
    (Int(SKKEventID.katakanaMode.rawValue), SKKInputMode.KatakanaInputMode, "jp.sourceforge.inputmethod.aquaskk.Katakana"),
    (Int(SKKEventID.jisx0201KanaMode.rawValue), SKKInputMode.Jisx0201KanaInputMode, "jp.sourceforge.inputmethod.aquaskk.HalfWidthKana"),
    (Int(SKKEventID.jisx0208LatinMode.rawValue), SKKInputMode.Jisx0208LatinInputMode, "jp.sourceforge.inputmethod.aquaskk.FullWidthRoman"),
    (Int(SKKEventID.asciiMode.rawValue), SKKInputMode.AsciiInputMode, "jp.sourceforge.inputmethod.aquaskk.Ascii"),
]

@objc(SKKInputMenu) public class SKKInputMenu: NSObject {
    nonisolated(unsafe) static var unifiedInputMode: SKKInputMode = .HirakanaInputMode

    private let client: IMKTextInput
    private var activated: Bool = true
    public private(set) var currentInputMode: SKKInputMode = .HirakanaInputMode
    public var unifiedInputMode: SKKInputMode {
        Self.unifiedInputMode
    }

    @objc(initWithClient:) public init(with client: IMKTextInput) {
        self.client = client
        super.init()
    }

    @objc public func updateMenu(_ mode: SKKInputMode) {
        guard let identifier = modeIdentifier(inputMode: mode) else {
            return
        }

        currentInputMode = mode
        Self.unifiedInputMode = mode
        if activated {
            Logger.skkInput.log("\(#function, privacy: .public): selectMode(\(identifier, privacy: .public)")
            client.selectMode(identifier)
        }
    }

    @objc public func activation() {
        Logger.skkInput.log("\(#function, privacy: .public)")
        activated = true
    }

    @objc public func deactivation() {
        Logger.skkInput.log("\(#function, privacy: .public)")
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

    func eventID(modeIdentifier: String) -> Int {
        for (eventID, _, identifier) in kInputModeTable {
            if identifier.caseInsensitiveCompare(modeIdentifier) == .orderedSame {
                return eventID
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
    public func getUnifiedInputMode() -> SKKInputMode {
        return Self.unifiedInputMode
    }

    // swiftformat:disable:next acronyms
    @objc(convertIdToInputMode:)
    public func convertIDToInputMode(modeIdentifier: String) -> SKKInputMode {
        return inputMode(modeIdentifier: modeIdentifier) ?? .InvalidInputMode
    }

    // swiftformat:disable:next acronyms
    @objc(convertIdToEventId:)
    public func convertIDToEventID(modeIdentifier: String) -> Int {
        return eventID(modeIdentifier: modeIdentifier)
    }

    // swiftformat:disable:next acronyms
    @objc(convertInputModeToId:)
    public func convertInputModeToID(inputMode: SKKInputMode) -> String {
        return modeIdentifier(inputMode: inputMode) ?? ""
    }
}
