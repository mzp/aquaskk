//
//  MockTextInput.swift
//  Harness
//
//  Created by mzp on 8/3/24.
//

import AquaSKKLogging
import Foundation
import InputMethodKit
import OSLog

public class MockTextInput: NSObject {
    var text = TyperState()
    var _selectedRange: NSRange = .init(location: 0, length: 0)
    var _markedRange: NSRange = .init(location: 0, length: 0)
}

extension MockTextInput: IMKTextInput {
    public func selectedRange() -> NSRange {
        return _selectedRange
    }

    public func markedRange() -> NSRange {
        return _markedRange
    }

    public func insertText(_ string: Any, replacementRange _: NSRange) {
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

    public func setMarkedText(
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

    public func attributedSubstring(from range: NSRange) -> NSAttributedString! {
        let string = (text.string as NSString).substring(with: range)
        return NSAttributedString(string: string)
    }

    public func length() -> Int {
        text.string.count
    }

    public func characterIndex(for _: NSPoint, tracking _: IMKLocationToOffsetMappingMode, inMarkedRange _: UnsafeMutablePointer<ObjCBool>!) -> Int {
        // TODO: Implement
        return 0
    }

    public func attributes(forCharacterIndex _: Int, lineHeightRectangle _: UnsafeMutablePointer<NSRect>!) -> [AnyHashable: Any]! {
        return [:]
    }

    public func validAttributesForMarkedText() -> [Any]! {
        []
    }

    public func overrideKeyboard(withKeyboardNamed _: String!) {}

    public func selectMode(_ modeIdentifier: String!) {
        Logger.skkTyper.info("""
        [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
        \(modeIdentifier, privacy: .private)
        """)
        text.modeIdentifier = modeIdentifier
    }

    public func supportsUnicode() -> Bool {
        true
    }

    public func bundleIdentifier() -> String! {
        Bundle.main.bundleIdentifier
    }

    public func windowLevel() -> CGWindowLevel {
        0
    }

    public func supportsProperty(_: TSMDocumentPropertyTag) -> Bool {
        return true
    }

    public func uniqueClientIdentifierString() -> String! {
        "com.aquaskk.inputmethod.client"
    }

    public func string(from range: NSRange, actualRange _: NSRangePointer!) -> String! {
        (text.string as NSString).substring(with: range)
    }

    public func firstRect(forCharacterRange _: NSRange, actualRange _: NSRangePointer!) -> NSRect {
        .zero
    }
}
