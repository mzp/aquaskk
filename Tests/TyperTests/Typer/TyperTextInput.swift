//
//  TyperTextInput.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import Foundation
import InputMethodKit

class TyperTextInput: NSObject {
    var text: String = ""
    var markedText: String = ""
    var modeIdentifier: String?

    var _selectedRange: NSRange = .init(location: 0, length: 0)
    var _markedRange: NSRange = .init(location: 0, length: 0)
}

extension TyperTextInput: IMKTextInput {
    func selectedRange() -> NSRange {
        return _selectedRange
    }

    func markedRange() -> NSRange {
        return _markedRange
    }

    func insertText(_ string: Any, replacementRange _: NSRange) {
        // TODO: Use replacementRange
        // TODO: Update selectedRange
        markedText.removeAll()
        text.append(string as! String)
    }

    func setMarkedText(
        _ value: Any?,
        selectionRange _: NSRange,
        replacementRange _: NSRange
    ) {
        // TODO: Use replacementRange
        // TODO: Update markedTextRange
        if let string = value as? NSString {
            markedText = string as String
        } else if let attributedString = value as? NSAttributedString {
            markedText = attributedString.string
        }
    }

    func attributedSubstring(from range: NSRange) -> NSAttributedString! {
        let string = (text as NSString).substring(with: range)
        return NSAttributedString(string: string)
    }

    func length() -> Int {
        text.count
    }

    func characterIndex(for _: NSPoint, tracking _: IMKLocationToOffsetMappingMode, inMarkedRange _: UnsafeMutablePointer<ObjCBool>!) -> Int {
        // TODO: Implement
        return 0
    }

    func attributes(forCharacterIndex _: Int, lineHeightRectangle _: UnsafeMutablePointer<NSRect>!) -> [AnyHashable: Any]! {
        return [:]
    }

    func validAttributesForMarkedText() -> [Any]! {
        []
    }

    func overrideKeyboard(withKeyboardNamed _: String!) {}

    func selectMode(_ modeIdentifier: String!) {
        self.modeIdentifier = modeIdentifier
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

    func supportsProperty(_: TSMDocumentPropertyTag) -> Bool {
        return true
    }

    func uniqueClientIdentifierString() -> String! {
        "org.codefirst.AquaSKK.client"
    }

    func string(from range: NSRange, actualRange _: NSRangePointer!) -> String! {
        (text as NSString).substring(with: range)
    }

    func firstRect(forCharacterRange _: NSRange, actualRange _: NSRangePointer!) -> NSRect {
        .zero
    }
}
