//
//  NSParagraphStyle+Mutable.swift
//  AquaSKKUI
//
//  Created by mzp on 2/1/25.
//

import AppKit

extension NSParagraphStyle {
    static func skk_mutableDefault() -> NSMutableParagraphStyle {
        let style = NSParagraphStyle.default.mutableCopy()
        return style as! NSMutableParagraphStyle
    }
}
