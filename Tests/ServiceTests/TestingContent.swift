//
//  TestingContent.swift
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

import Foundation
import OSLog
import Testing

private let logger = Logger(subsystem: "org.codefirst.AquaSKK", category: "Test")

/// テスト用データに簡単にアクセスするためのメソッド群を提供するクラス
class TestingContent {
    static var shared = TestingContent()
    private var bundle: Bundle {
        Bundle(for: TestingContent.self)
    }

    /// テスト用リソースを置いてあるディレクトリ
    var resourcePath: String {
        bundle.resourcePath!
    }

    /// テスト用ファイルのパスを取得する
    /// @param filename ファイル名
    /// @param writable (optional) 書き込み可能なパスを返す。書き込んだ内容はテスト終了後に自動的に破棄される。
    /// @return 絶対ファイルパス
    func path(_ filename: String, writable: Bool = false) throws -> String {
        let resource = (filename as NSString).deletingPathExtension
        let type = (filename as NSString).pathExtension
        let path = try #require(bundle.path(forResource: resource, ofType: type))
        let fm = FileManager.default

        if writable {
            let tempPath = NSTemporaryDirectory().appending("/\(filename)")
            logger.info("Copy \(path) to \(tempPath)")
            _ = try? fm.removeItem(atPath: tempPath)
            try fm.copyItem(atPath: path, toPath: tempPath)
            return tempPath
        } else {
            return path
        }
    }
}
