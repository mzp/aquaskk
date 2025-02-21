//
//  SKKDictionaryKeeper.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/20/25.
//

import Foundation

protocol SKKDictionaryDataSource {
    var okuriAri: [SKKDictionaryEntryImpl] { get }
    var okuriNasi: [SKKDictionaryEntryImpl] { get }
}

// 辞書の読み書き w/ 文字コード変換
class SKKDictionaryKeeper {
    var dataSource: SKKDictionaryDataSource?

    let encoding: String.Encoding
    init(encoding: String.Encoding) {
        self.encoding = encoding
    }

    func findOkuriAri(query: String) -> String? {
        guard let dataSource = dataSource else {
            return nil
        }
        return fetch(query: query, entries: dataSource.okuriAri)
    }
    func findOkuriNasi(query: String) -> String? {
        guard let dataSource = dataSource else {
            return nil
        }
        return fetch(query: query, entries: dataSource.okuriNasi)
    }

    func fetch(query: String, entries: [SKKDictionaryEntryImpl]) -> String? {
        let entry = entries.first(where: {
            $0.entryString(using: encoding) == query
        })
        return entry?.valueString(using: encoding)
    }
}
