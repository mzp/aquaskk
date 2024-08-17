//
//  InputMethodKitAdapter.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import AppKit
import Foundation
import InputMethodKit
import OSLog

private let logger = Logger(subsystem: "com.aquaskk.inputmethod.Harness", category: "Adapter")

class InputMethodKitAdapter: NSObject, IMKTextInput {
    let inputClient: NSTextInputClient
    var store: SKKStateStore

    init(inputClient: NSTextInputClient, store: SKKStateStore) {
        self.inputClient = inputClient
        self.store = store
    }

    func insertText(_ string: Any, replacementRange: NSRange) {
        inputClient.insertText(string, replacementRange: replacementRange)
    }

    func setMarkedText(
        _ string: Any?,
        selectionRange: NSRange,
        replacementRange: NSRange
    ) {
        inputClient
            .setMarkedText(
                string ?? "",
                selectedRange: selectionRange,
                replacementRange: replacementRange
            )
    }

    func selectedRange() -> NSRange {
        inputClient.selectedRange()
    }

    func markedRange() -> NSRange {
        inputClient.markedRange()
    }

    func attributedSubstring(from range: NSRange) -> NSAttributedString! {
        inputClient.attributedSubstring(forProposedRange: range, actualRange: nil)
    }

    func length() -> Int {
        inputClient.attributedString?().length ?? 0
    }

    func characterIndex(for point: NSPoint, tracking _: IMKLocationToOffsetMappingMode, inMarkedRange _: UnsafeMutablePointer<ObjCBool>!) -> Int {
        inputClient.characterIndex(for: point)
    }

    func attributes(forCharacterIndex _: Int, lineHeightRectangle _: UnsafeMutablePointer<NSRect>!) -> [AnyHashable: Any]! {
        return [:]
    }

    func validAttributesForMarkedText() -> [Any]! {
        inputClient.validAttributesForMarkedText()
    }

    func overrideKeyboard(withKeyboardNamed keyboardUniqueName: String!) {
        logger.log("\(#function): \(keyboardUniqueName)")
        store.keyboardLayout = keyboardUniqueName
    }

    func selectMode(_ modeIdentifier: String!) {
        logger.log("\(#function): \(modeIdentifier)")
        store.modeIdentifier = modeIdentifier
    }

    func supportsUnicode() -> Bool {
        true
    }

    func bundleIdentifier() -> String! {
        Bundle.main.bundleIdentifier
    }

    func windowLevel() -> CGWindowLevel {
        0
    }

    func supportsProperty(_ property: TSMDocumentPropertyTag) -> Bool {
        logger.warning("\(#function): \(property)")
        return true
    }

    func uniqueClientIdentifierString() -> String! {
        "com.aquaskk.inputmethod.client"
    }

    func string(from range: NSRange, actualRange: NSRangePointer!) -> String! {
        inputClient
            .attributedSubstring(
                forProposedRange: range,
                actualRange: actualRange
            )?.string
    }

    func firstRect(forCharacterRange aRange: NSRange, actualRange: NSRangePointer!) -> NSRect {
        inputClient.firstRect(forCharacterRange: aRange, actualRange: actualRange)
    }
}
