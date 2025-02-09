//
//  MacClipboardImpl.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import AppKit
import Foundation

@objc(MacClipboardImpl)
public class MacClipboardImpl: NSObject {
    override public init() {
        super.init()
    }

    @objc public func pasteString() -> String {
        let pasteboard = NSPasteboard.general
        return pasteboard.string(forType: .string) ?? ""
    }
}
