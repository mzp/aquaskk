//
//  SKKTextView.swift
//  AquaSKKIM
//
//  Created by mzp on 8/3/24.
//

import AppKit
import AquaSKKIM
import Foundation
import InputMethodKit
import OSLog
import SwiftUI

class SKKAdapter: NSObject, IMKTextInput {
    private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "Adapter")

    let inputClient: NSTextInputClient
    init(inputClient: NSTextInputClient) {
        self.inputClient = inputClient
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
        logger.info("\(#function): \(keyboardUniqueName)")
    }

    func selectMode(_ modeIdentifier: String!) {
        logger.info("\(#function): \(modeIdentifier)")
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
        "org.codefirst.AquaSKK.client"
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

    //    let textView: NSTextView
}

class SKKTextViewImpl: NSTextView {
    let logger = Logger(subsystem: "org.codefirst.AquaSKK.Harness", category: "TextView")

    lazy var client: IMKTextInput = SKKAdapter(inputClient: self)

    var controller: IMKInputController?

    override func keyDown(with event: NSEvent) {
        logger.info("\(#function): \(event)")
        let handled = controller?.handle(event, client: client)
        if !(handled ?? false) {
            super.keyDown(with: event)
        }
    }
}

struct SKKTextView: NSViewRepresentable {
    var controller: SKKInputController
    func makeNSView(context _: Context) -> SKKTextViewImpl {
        let view = SKKTextViewImpl()
        view.controller = controller
        controller._setClient(view.client)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func updateNSView(_ textView: SKKTextViewImpl, context _: Context) {
        textView.controller = controller
    }
}