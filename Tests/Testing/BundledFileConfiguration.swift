//
//  BundledFileConfiguration.swift
//  ServiceTests
//
//  Created by mzp on 8/11/24.
//

import AquaSKKService
import Foundation
import OSLog

private let logger = Logger(subsystem: "com.aquaskk.inputmethod", category: "Test")

public struct BundledFileConfiguration: FileConfiguration {
    public var systemResourcePath: String {
        assert(bundle.resourcePath != nil)
        return bundle.resourcePath!
    }

    public var applicationSupportPath: String

    public var bundle: Bundle
    public init(bundle: Bundle) throws {
        self.bundle = bundle
        // 並列実行できるよう書き込み可能なパスはユニークする
        applicationSupportPath = NSTemporaryDirectory().appending("\(UUID().uuidString)")
        try copy(files: ["DictionarySet.plist"])
    }

    func copy(files: [String]) throws {
        let fileManager = FileManager.default
        try fileManager.createDirectory(atPath: applicationSupportPath, withIntermediateDirectories: true)

        let targetPath = applicationSupportPath
        logger.info("Application Support = \(targetPath)")

        for file in files {
            let path = targetPath.appending("/\(file)")
            _ = try? fileManager.removeItem(atPath: path)

            let source = systemResourcePath.appending("/\(file)")

            try fileManager.copyItem(atPath: source, toPath: path)
        }
    }
}
