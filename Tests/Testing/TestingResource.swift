//
//  TestingResource.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/15/24.
//

import Foundation
import OSLog

/// テスト用データに簡単にアクセスするためのメソッド群を提供するクラス
public class TestingResource {
    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    /// テスト用ファイルのパスを取得する
    /// @param filename ファイル名
    /// @param writable (optional) 書き込み可能なパスを返す。書き込んだ内容はテスト終了後に自動的に破棄される。
    /// @return 絶対ファイルパス
    public func path(_ filename: String, writable: Bool = false) throws -> String {
        let resource = (filename as NSString).deletingPathExtension
        let type = (filename as NSString).pathExtension
        let path = bundle.path(forResource: resource, ofType: type)!
        let fm = FileManager.default

        if writable {
            let tempDir = NSTemporaryDirectory().appending("/\(UUID().uuidString)")
            try fm.createDirectory(atPath: tempDir, withIntermediateDirectories: true)

            let tempPath = tempDir.appending("/\(filename)")
            Logger.testing.log("Copy \(path) to \(tempPath)")
            _ = try? fm.removeItem(atPath: tempPath)
            try fm.copyItem(atPath: path, toPath: tempPath)
            return tempPath
        } else {
            return path
        }
    }
}
