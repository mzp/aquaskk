//
//  BundledFileConfiguration.swift
//  ServiceTests
//
//  Created by mzp on 8/11/24.
//

import AquaSKKService
import Foundation
import OSLog

private let logger = Logger(subsystem: "org.codefirst.AquaSKK", category: "Test")

public struct BundledFileConfiguration: FileConfiguration {
    public var systemResourcePath: String {
        assert(bundle.resourcePath != nil)
        return bundle.resourcePath!
    }

    public var applicationSupportPath: String {
        NSTemporaryDirectory()
    }

    public var bundle: Bundle
    public init(bundle: Bundle) throws {
        self.bundle = bundle

        let fileManager = FileManager.default
        let path = systemResourcePath.appending("/DictionarySet.plist")

        let destPath = dictionarySetPath
        logger.info("Copy \(path) to \(destPath)")
        _ = try? fileManager.removeItem(atPath: destPath)
        try fileManager.copyItem(atPath: path, toPath: destPath)
    }
}
