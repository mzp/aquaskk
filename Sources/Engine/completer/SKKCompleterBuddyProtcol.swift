//
//  SKKCompleterBuddyProtcol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/29.
//

import Foundation
// 補完サポートクラス
@objc public protocol SKKCompleterBuddyProtcol {
    // 見出し語の取得
    @objc func completerQueryString() -> String

    // 現在の見出し語の通知
    @objc func completerUpdate(entry: String)
}
