//
//  MockTextInput.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

internal import AquaSKKTesting
import AquaSKKLogging
import Foundation
import InputMethodKit
import OSLog

class MockTextInput: NSObject {
    var text = SendableText()
    var _selectedRange: NSRange = .init(location: 0, length: 0)
    var _markedRange: NSRange = .init(location: 0, length: 0)
}

extension MockTextInput: IMKTextInput {
    func selectedRange() -> NSRange {
        return _selectedRange
    }

    func markedRange() -> NSRange {
        return _markedRange
    }

    func insertText(_ string: Any, replacementRange _: NSRange) {
        // TODO: Use replacementRange
        // TODO: Update selectedRange
        text.marked.removeAll()
        text.string.append(string as! String)

        Logger.skkTyper.info("""
        [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
        string="\(self.text.string, privacy: .private)"(length=\(self.text.string.count, privacy: .public)) \        
        marked="\(self.text.marked, privacy: .private)"(length=\(self.text.marked.count, privacy: .public))
        """)
    }

    func setMarkedText(
        _ value: Any?,
        selectionRange: NSRange,
        replacementRange _: NSRange
    ) {
        // TODO: Use replacementRange
        // TODO: Update markedTextRange
        if let string = value as? NSString {
            text.marked = string as String
        } else if let attributedString = value as? NSAttributedString {
            text.marked = attributedString.string
        }
        text.markedTextRange = selectionRange

        Logger.skkTyper.info("""
        [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
        "\(self.text.marked, privacy: .private)"(length=\(self.text.marked.count, privacy: .public)) \
        \(self.text.markedTextRange, privacy: .public)
        """)
    }

    func attributedSubstring(from range: NSRange) -> NSAttributedString! {
        let string = (text.string as NSString).substring(with: range)
        return NSAttributedString(string: string)
    }

    func length() -> Int {
        text.string.count
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
        Logger.skkTyper.info("""
        [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
        \(modeIdentifier, privacy: .private)
        """)
        text.modeIdentifier = modeIdentifier
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
        "com.aquaskk.inputmethod.client"
    }

    func string(from range: NSRange, actualRange _: NSRangePointer!) -> String! {
        (text.string as NSString).substring(with: range)
    }

    func firstRect(forCharacterRange _: NSRange, actualRange _: NSRangePointer!) -> NSRect {
        .zero
    }
}
