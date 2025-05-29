//
//  SKKCompleterBuddyProtcol.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/05/29.
//

import Foundation
// 補完サポートクラス
@objc public protocol SKKCompleterBuddyProtcol {
    @objc func completerQueryString() -> String
    @objc func completerUpdate(entry: String)
}
