//
//  BundledServerConfiguration.swift
//  AquaSKKService
//
//  Created by mzp on 8/14/24.
//

import AquaSKKService
import OSLog

private let logger = Logger(subsystem: "com.aquaskk.inputmethod.Harness", category: "Configuration")

public class BundledServerConfiguration: ServerConfiguration {
    private let bundle: Bundle

    public init(bundle: Bundle) throws {
        Logger.testing.log("\(#function): \(bundle)")
        self.bundle = bundle

        applicationSupportPath = NSTemporaryDirectory().appending("\(UUID().uuidString)/")
        systemResourcePath = bundle.resourcePath!

        try copy(files: ["DictionarySet.plist"])
    }

    // MARK: - Readonly path

    public let systemResourcePath: String

    public var factoryUserDefaultsPath: String {
        path(forName: "UserDefaults.plist")
    }

    public func systemDictionaries() -> [[AnyHashable: Any]] {
        let path = bundle.path(forResource: "SKK-JISYO.S", ofType: "txt")!
        return [
            Jisyo(type: .common, location: path, enabled: true).dictionary,
        ]
    }

    public func systemPath(forName name: String) -> String {
        path(forName: name)
    }

    // MARK: - Writable

    public let applicationSupportPath: String
    public var userDefaultsPath: String {
        applicationSupportPath.appending("UserDefaults.plist")
    }

    public var dictionarySetPath: String {
        return applicationSupportPath.appending("DictionarySet.plist")
    }

    public func path(forName name: String) -> String {
        let basename = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        guard let path = bundle.path(forResource: basename, ofType: ext) else {
            logger.error("Can't find \(name)")
            return ""
        }
        return path
    }

    public func userPath(forName name: String) -> String {
        path(forName: name)
    }

    public var userDictionaryPath: String {
        applicationSupportPath.appending("/user-jisyo")
    }

    func copy(files: [String]) throws {
        let fileManager = FileManager.default
        try fileManager.createDirectory(atPath: applicationSupportPath, withIntermediateDirectories: true)

        let targetPath = applicationSupportPath
        Logger.testing.log("Application Support = \(targetPath)")

        for file in files {
            let path = targetPath.appending("/\(file)")
            _ = try? fileManager.removeItem(atPath: path)

            let source = systemResourcePath.appending("/\(file)")

            try fileManager.copyItem(atPath: source, toPath: path)
        }
    }
}
