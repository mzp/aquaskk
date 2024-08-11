//
//  FileConfiguration.swift
//  AquaSKKCore
//
//  Created by mzp on 8/11/24.
//

import Foundation

public protocol FileConfiguration {
    var systemResourcePath: String { get }
    var applicationSupportPath: String { get }
    var dictionarySetPath: String { get }
}

public extension FileConfiguration {
    var dictionarySetPath: String {
        return "\(applicationSupportPath)/DictionarySet.plist"
    }
}

public struct DefaultFileConfiguration: FileConfiguration {
    public init() {}
    public var systemResourcePath: String {
        "/Library/Input Methods/AquaSKK.app/Contents/Resources"
    }

    public var applicationSupportPath: String {
        return "\(NSHomeDirectory())/Library/Application Support/AquaSKK"
    }
}

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
