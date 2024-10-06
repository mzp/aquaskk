//
//  DictionaryFile.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/14/24.
//

import Foundation
import OSLog

let kOkuriAriMark = ";; okuri-ari entries."
let kOkuriNasiMark = ";; okuri-nasi entries."

struct DictionaryEntry: Equatable, Hashable, Sendable {
    /// 見出し語
    var entry: String

    /// 変換候補(分解する前の状態)
    var rawValue: String

}

typealias DictionaryEntryContainer = [DictionaryEntry]

/// SKK 辞書ファイル
struct DictionaryFile {
    struct DictionaryFileError: Error {}

    var okuriAri: DictionaryEntryContainer = []
    var okuriNasi: DictionaryEntryContainer = []

    mutating func load(path: String) async throws {
        okuriAri.removeAll()
        okuriNasi.removeAll()

        guard FileManager.default.fileExists(atPath: path) else {
            Logger.backend
                .error(
                    "\(#function, privacy: .public): can't open: \(path, privacy: .private)"
                )
            throw DictionaryFileError()
        }

        var iterator = URL(filePath: path).lines.makeAsyncIterator()
        while let line = try await iterator.next() {
            if line.contains(kOkuriAriMark) {
                break
            }
        }
        while let line = try await iterator.next() {
            if line.contains(kOkuriNasiMark) {
                break
            }
            okuriAri.append(fetch(from: line))
        }
        while let line = try await iterator.next() {
            okuriNasi.append(fetch(from: line))
        }
    }

    private func fetch(from line: String) -> DictionaryEntry {
        let parsed = line.split(separator: " ", maxSplits: 1)

        return .init(entry: String(parsed[0]), rawValue: String(parsed[1]))
    }

    func save(path: String) throws {
        FileManager.default.createFile(atPath: path, contents: nil)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            throw DictionaryFileError()
        }
        try store(to: fileHandle, line: kOkuriAriMark)
        try store(to: fileHandle, entries: okuriAri)

        try store(to: fileHandle, line: kOkuriNasiMark)
        try store(to: fileHandle, entries: okuriNasi)
    }

    var isEmpty: Bool {
        okuriAri.isEmpty && okuriNasi.isEmpty
    }

    mutating func sort() {
        okuriAri.sort(by: {
            $0.entry < $1.entry
        })
        okuriNasi.sort(by: {
            $0.entry < $1.entry
        })
    }

    private func store(to handle: FileHandle, line: String) throws {
        guard let data = (line + "\n").data(using: .utf8) else {
            throw DictionaryFileError()
        }
        try handle.write(contentsOf: data)
    }

    private func store(to handle: FileHandle, entries: DictionaryEntryContainer) throws {
        for entry in entries {
            try store(to: handle, line: "\(entry.entry) \(entry.rawValue)")
        }
    }
}
