//
//  FileConfiguration.swift
//  AquaSKKCore
//
//  Created by mzp on 8/11/24.
//

// TODO: SKKFilePathsへの依存を置き換える
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
