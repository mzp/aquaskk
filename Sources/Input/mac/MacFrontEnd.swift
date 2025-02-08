//
//  MacFrontEnd.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import InputMethodKit
import OSLog

extension NSRange {
    static let skkNotFound: NSRange = .init(location: NSNotFound, length: NSNotFound)
}

@objc(MacFrontEndImpl)
public class MacFrontEndImpl: NSObject {
    private let client: IMKTextInput

    @objc(initWithClient:) public init(client: IMKTextInput) {
        self.client = client
        super.init()
    }

    @objc(insertString:)
    @MainActor public func insert(string: String) {
        if !string.isEmpty {
            willInsertText(string)
        }
        client.insertText(string, replacementRange: .skkNotFound)
    }

    @objc public func composeString(_ string: String, cursorOffset: Int) {
        let marked = markedText(string, cursorOffset: cursorOffset)
        let cursorPos = NSRange(location: marked.length + cursorOffset, length: 0)

        // *** FIXME ***
        // Carbon アプリで見出し語を入力すると、なぜか文字のベースラインが下にずれる
        // 一旦 "▽" だけ入力すると回避できるが、正解かどうかは不明
        if string == "▽" {
            client.setMarkedText("▽", selectionRange: .skkNotFound, replacementRange: .skkNotFound)
        }
        client.setMarkedText(marked, selectionRange: cursorPos, replacementRange: .skkNotFound)
    }

    @objc public func composeString(_ string: String,
                                    candidateStart: Int, candidateLength: Int)
    {
        let marked = markedText(string, cursorOffset: 0)
        let cursorPos = NSRange(location: marked.length, length: 0)
        let segment = NSRange(location: candidateStart, length: candidateLength)

        marked.addAttribute(.markedClauseSegment, value: 0, range: segment)
        marked.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: segment)

        client.setMarkedText(marked, selectionRange: cursorPos, replacementRange: .skkNotFound)
    }

    @objc public func selectedString() -> String {
        let range = client.selectedRange()
        let text = client.attributedSubstring(from: range)
        guard let string = text?.string else {
            return ""
        }

        return string
    }

    private func markedText(_ string: String, cursorOffset: Int) -> NSMutableAttributedString {
        let marked = NSMutableAttributedString(string: string)
        marked.addAttribute(.cursor, value: NSCursor.iBeam, range: NSRange(location: marked.length + cursorOffset, length: 0))
        marked.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: marked.length))
        return marked
    }

    // MARK: - Workaround

    @MainActor
    private func willInsertText(_ string: String) {
        guard let bundleIdentifier = client.bundleIdentifier() else {
            Logger.skkInput.warning("\(#function)  client.bundleIdentifier is nil")
            return
        }
        guard BlacklistApps.shared().needsInsertMarkedText(bundleIdentifier: bundleIdentifier) else {
            return
        }

        // 確定前に、非確定文字列に確定予定文字列をセットするとうまくいく
        Logger.skkInput.log("\(#function) insert marked text: \(string, privacy: .private)")

        client.setMarkedText(string, selectionRange: .skkNotFound, replacementRange: .skkNotFound)
        // 正しいかどうかは不明
    }
}
