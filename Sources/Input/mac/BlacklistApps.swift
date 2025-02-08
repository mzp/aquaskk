//
//  BlacklistApps.swift
//  AquaSKKInput
//
//  Created by mzp on 2/7/25.
//

import Foundation
import OSLog

@objc(BlacklistApps)
public class BlacklistApps: NSObject {
    public typealias AppEntry = [String: Any]

    private var apps: [AppEntry]
    override public init() {
        apps = []
    }

    @MainActor private static let sharedInstance = BlacklistApps()
    @MainActor @objc(sharedManager) public static func shared() -> BlacklistApps {
        return sharedInstance
    }

    @objc public func load(_ apps: [AppEntry]) {
        self.apps = apps
    }

    @objc(needsInsertEmptyString:)
    public func needsInsertEmptyString(bundle: Bundle) -> Bool {
        if let bundleIdentifier = bundle.bundleIdentifier {
            if let entry = entry(bundleIdentifier: bundleIdentifier) {
                return bool(entry: entry, key: "insertEmptyString")
            }
        } else {
            Logger.skkInput.warning("Could not get bundle identifier from bundle \(bundle)")
        }

        if isJavaApp(bundle: bundle) {
            return true
        }

        // very special apps
        if bundle.bundleIdentifier == "com.microsoft.Excel",
           let version = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
           version.hasPrefix("15.")
        {
            return true
        }
        return false
    }

    public func needsInsertMarkedText(bundleIdentifier: String) -> Bool {
        guard let entry = entry(bundleIdentifier: bundleIdentifier) else {
            return false
        }
        return bool(entry: entry, key: "insertMarkedText")
    }

    @objc(needsSyncInputSource:)
    public func needsSyncInputSource(bundle: Bundle) -> Bool {
        guard let bundleIdentifier = bundle.bundleIdentifier else {
            Logger.skkInput.warning("Failed to get bundleIdentifier from \(bundle)")
            return false
        }
        guard let entry = entry(bundleIdentifier: bundleIdentifier) else {
            return false
        }
        return bool(entry: entry, key: "syncInputSource")
    }

    // MARK: - Objective-C

    @available(*, deprecated, renamed: "needsInsertEmptyString")
    @objc public func isInsertEmptyString(_ bundle: Bundle) -> Bool {
        return needsInsertEmptyString(bundle: bundle)
    }

    @available(*, deprecated, renamed: "needsInsertMarkedText")
    @objc public func isInsertMarkedText(_ bundleIdentifier: String) -> Bool {
        return needsInsertMarkedText(bundleIdentifier: bundleIdentifier)
    }

    @available(*, deprecated, renamed: "needsSyncInputSource")
    @objc public func isSyncInputSource(_ bundle: Bundle) -> Bool {
        return needsSyncInputSource(bundle: bundle)
    }

    // MARK: - Entry

    private func entry(bundleIdentifier target: String) -> AppEntry? {
        return apps.first { entry in
            guard let prefix = bundleIdentifier(entry: entry) else {
                return false
            }
            return target.hasPrefix(prefix)
        }
    }

    private func bundleIdentifier(entry: AppEntry) -> String? {
        get(entry: entry, key: "bundleIdentifier", type: String.self)
    }

    private func bool(entry: AppEntry, key: String) -> Bool {
        get(entry: entry, key: key, type: Bool.self) ?? false
    }

    private func get<T>(entry: AppEntry, key: String, type _: T.Type = T.self) -> T? {
        return entry[key] as? T
    }

    // MARK: - Query

    private func isJavaApp(bundle: Bundle) -> Bool {
        if bundle.bundleIdentifier?.hasPrefix("jp.naver.line.mac") == true {
            return true
        }
        if bundle.object(forInfoDictionaryKey: "Java") != nil {
            return true
        }
        if bundle.object(forInfoDictionaryKey: "Eclipse") != nil {
            return true
        }
        if bundle.object(forInfoDictionaryKey: "JVMOptions") != nil {
            return true
        }
        return false
    }
}
