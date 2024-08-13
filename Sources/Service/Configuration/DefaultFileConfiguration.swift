//
//  DefaultFileConfiguration.swift
//  AquaSKKService
//
//  Created by mzp on 8/14/24.
//

public struct DefaultFileConfiguration: FileConfiguration {
    public init() {}
    public var systemResourcePath: String {
        "/Library/Input Methods/AquaSKK.app/Contents/Resources"
    }

    public var applicationSupportPath: String {
        return "\(NSHomeDirectory())/Library/Application Support/AquaSKK"
    }
}
