//
//  BundledFileConfiguration.swift
//  ServiceTests
//
//  Created by mzp on 8/11/24.
//

import AquaSKKService
import Foundation

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
        _ = try? fileManager.removeItem(atPath: dictionarySetPath)
        try fileManager.copyItem(atPath: path, toPath: dictionarySetPath)
    }
}
