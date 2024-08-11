//
//  FileConfiguration.swift
//  AquaSKKCore
//
//  Created by mzp on 8/11/24.
//

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
