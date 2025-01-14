//
//  ServiceTesting.swift
//  AquaSKKService
//
//  Created by mzp on 8/8/24.
//

import Foundation
import OSLog
import Testing

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "Test")

/// テスト用データに簡単にアクセスするためのメソッド群を提供するクラス
class ServiceTesting {
    static var shared = ServiceTesting()
    var bundle: Bundle {
        Bundle(for: ServiceTesting.self)
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
            let tempDir = NSTemporaryDirectory().appending("/\(UUID().uuidString)")
            try fm.createDirectory(atPath: tempDir, withIntermediateDirectories: true)

            let tempPath = tempDir.appending("/\(filename)")
            logger.log("Copy \(path) to \(tempPath)")
            _ = try? fm.removeItem(atPath: tempPath)
            try fm.copyItem(atPath: path, toPath: tempPath)
            return tempPath
        } else {
            return path
        }
    }
}
