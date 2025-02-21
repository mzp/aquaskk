//
//  SKKDictionaryFile.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/17/25.
//

import AquaSKKLogging
import Foundation
import OSLog

public class SKKDictionaryFileImpl: NSObject, SKKDictionaryDataSource {
    struct SKKDictionaryFileError: Error {}

    var okuriAri: [SKKDictionaryEntryImpl] = []
    var okuriNasi: [SKKDictionaryEntryImpl] = []

    @objc public func save(path: String) throws {
        let space = Character(" ").asciiValue!
        let newline = Character("\n").asciiValue!

        FileManager.default.createFile(atPath: path, contents: nil)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            throw SKKDictionaryFileError()
        }
        try fileHandle.write(contentsOf: kOkuriAriMark.data(using: .ascii)!)
        try fileHandle.write(contentsOf: [newline])

        for entry in okuriAri {
            try fileHandle.write(contentsOf: entry.entry)
            try fileHandle.write(contentsOf: [space])
            try fileHandle.write(contentsOf: entry.value)
            try fileHandle.write(contentsOf: [newline])
        }
        try fileHandle.write(contentsOf: kOkuriNasiMark.data(using: .ascii)!)
        try fileHandle.write(contentsOf: [newline])

        for entry in okuriNasi {
            try fileHandle.write(contentsOf: entry.entry)
            try fileHandle.write(contentsOf: [space])
            try fileHandle.write(contentsOf: entry.value)
            try fileHandle.write(contentsOf: [newline])
        }
    }

    @objc public func load(path: String) async throws {
        okuriAri.removeAll()
        okuriNasi.removeAll()

        guard FileManager.default.fileExists(atPath: path) else {
            Logger.skkBackend
                .error(
                    "\(#function, privacy: .public): can't open: \(path, privacy: .private)"
                )
            throw SKKDictionaryFileError()
        }
        let parser = DictionaryEntryParser(input: URL(filePath: path).resourceBytes.makeAsyncIterator())
        do {
            let (okuriAri, okuriNasi) = try await parser.entries()
            self.okuriAri = okuriAri
            self.okuriNasi = okuriNasi
        } catch {
            Logger.skkBackend
                .error(
                    "\(#function, privacy: .public): can't open: \(error, privacy: .public)")
            throw error
        }
    }

    @objc func isEmpty() -> Bool {
        return okuriAri.isEmpty && okuriNasi.isEmpty
    }

    @objc func sort() {
        okuriAri.sort(by: {
            $0.entry.lexicographicallyPrecedes($1.entry)
        })
        okuriNasi.sort(by: {
            $0.entry.lexicographicallyPrecedes($1.entry)
        })
    }

    // bridge
    func fetchOkuriAri() {}
    func fetchOkuriNasi() {}
    func setOkuriAri(_ okuriAri: [SKKDictionaryEntryImpl]) {
        self.okuriAri = okuriAri
    }

    func setOkuriNasi(_ okuriNasi: [SKKDictionaryEntryImpl]) {
        self.okuriNasi = okuriNasi
    }
}
