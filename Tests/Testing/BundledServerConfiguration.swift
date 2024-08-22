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

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    public var userDefaultsPath: String {
        NSTemporaryDirectory().appending("UserDefaults.plist")
    }

    public var factoryUserDefaultsPath: String {
        path(forName: "UserDefaults.plist")
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

    public func systemPath(forName name: String) -> String {
        path(forName: name)
    }

    public func userPath(forName name: String) -> String {
        path(forName: name)
    }

    public func userDictionaryPath() -> String? {
        NSTemporaryDirectory().appending("/user-jisyo")
    }

    public func systemDictionaries() -> [[AnyHashable: Any]] {
        let path = bundle.path(forResource: "SKK-JISYO.S", ofType: "txt")!
        return [
            Jisyo(type: .common, location: path, enabled: true).dictionary,
        ]
    }
}
