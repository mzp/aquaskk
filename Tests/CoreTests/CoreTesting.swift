//
//  CoreTesting.swift
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

import Foundation
import OSLog
import Testing

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "Test")

/// テスト用データに簡単にアクセスするためのメソッド群を提供するクラス
class CoreTesting {
    static var shared = CoreTesting()
    var bundle: Bundle {
        Bundle(for: CoreTesting.self)
    }

    /// テスト用ファイルのパスを取得する
    /// @param filename ファイル名
    /// @return 絶対ファイルパス
    func path(_ filename: String, writable _: Bool = false) throws -> String {
        let resource = (filename as NSString).deletingPathExtension
        let type = (filename as NSString).pathExtension
        return try #require(bundle.path(forResource: resource, ofType: type))
    }
}
