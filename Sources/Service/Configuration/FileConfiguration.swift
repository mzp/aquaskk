//
//  FileConfiguration.swift
//  AquaSKKCore
//
//  Created by mzp on 8/11/24.
//

/// 動作に必要なファイルへのパス。 単体テストを行うため差し替え可能にする。
public protocol FileConfiguration {
    var systemResourcePath: String { get }
    var applicationSupportPath: String { get }

    /// 辞書情報を保存するplistへのパス。要書き込み権限。
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
