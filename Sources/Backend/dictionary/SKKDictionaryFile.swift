//
//  SKKDictionaryFile.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/17/25.
//

import AquaSKKLogging
import Foundation
import OSLog

struct SKKDictionaryEntryImpl: Equatable {
    var entry: [UInt8]
    var value: [UInt8]

    init(entry: [UInt8], value: [UInt8]) {
        self.entry = entry
        self.value = value
    }

    init(entry: String, value: String) {
        self.entry = Array(entry.utf8)
        self.value = Array(value.utf8)
    }

    func takeBridgeObject() -> SKKDictionaryEntry {
        return .init(
            first: SKKUnsafeString(entry),
            second: SKKUnsafeString(value)
        )
    }
}

class DictionaryEntryParser<T: AsyncIteratorProtocol> where T.Element == UInt8 {
    typealias Element = T.Element
    struct UnexpectedTokenError: Error {}
    var input: T
    init(input: T) {
        self.input = input
    }

    func entries() async throws -> ([SKKDictionaryEntryImpl], [SKKDictionaryEntryImpl]) {
        _ = try await many {
            try await not(kOkuriAriMark)
        }
        let okuriAri = try await many {
            let entry = try await entry()

            if let value = String(
                bytes: entry.value,
                encoding: .ascii
            ), kOkuriNasiMark.hasSuffix(value) {
                throw UnexpectedTokenError()
            }
            return entry
        }

        let okuriNasi = try await many {
            try await entry()
        }

        return (okuriAri, okuriNasi)
    }

    func not(_ expect: String) async throws -> [T.Element] {
        let input = try await anyLine()
        if input == Array(expect.utf8) {
            throw UnexpectedTokenError()
        }
        return input
    }

    func entry() async throws -> SKKDictionaryEntryImpl {
        let entry = try await token {
            $0 == Character(" ").asciiValue
        }
        let value = try await anyLine()

        return SKKDictionaryEntryImpl(entry: entry, value: value)
    }

    func token(until: (T.Element) -> Bool) async throws -> [T.Element] {
        var buffer = [T.Element]()

        while true {
            guard let value = try await input.next() else {
                if buffer.isEmpty {
                    throw UnexpectedTokenError()
                } else {
                    return buffer
                }
            }
            if until(value) {
                return buffer
            }
            buffer.append(value)
        }
    }

    func anyLine() async throws -> [T.Element] {
        try await token {
            $0 == Character("\n").asciiValue
        }
    }

    func many<Result>(parser: () async throws -> Result) async throws -> [Result] {
        var result = [Result]()
        do {
            while true {
                let value = try await parser()
                result.append(value)
            }
        } catch _ as UnexpectedTokenError {}
        return result
    }
}

public class SKKDictionaryFileImpl: NSObject {
    override init() {
        super.init()
    }

    var okuriAri: [SKKDictionaryEntryImpl] = []
    var okuriNasi: [SKKDictionaryEntryImpl] = []

    @objc public func save(path _: String) -> Bool {
        let space = Character(" ").asciiValue!
        var data = Data()

        data.append(kOkuriAriMark.data(using: .ascii)!)
        for entry in okuriAri {
            data.append(contentsOf: entry.entry)
            data.append(contentsOf: [space])
            data.append(contentsOf: entry.value)
        }
        data.append(kOkuriNasiMark.data(using: .ascii)!)

        for entry in okuriNasi {
            data.append(contentsOf: entry.entry)
            data.append(contentsOf: [space])
            data.append(contentsOf: entry.value)
        }
        return true
    }

    @objc public func load(path: String) async -> Bool {
        okuriAri.removeAll()
        okuriNasi.removeAll()

        guard FileManager.default.fileExists(atPath: path) else {
            Logger.skkBackend
                .error(
                    "\(#function, privacy: .public): can't open: \(path, privacy: .private)"
                )
            return false
        }
        let parser = DictionaryEntryParser(input: URL(filePath: path).resourceBytes.makeAsyncIterator())
        do {
            let (okuriAri, okuriNasi) = try await parser.entries()
            self.okuriAri = okuriAri
            self.okuriNasi = okuriNasi
            return true
        } catch {
            Logger.skkBackend
                .error(
                    "\(#function, privacy: .public): can't open: \(error, privacy: .public)")
            return false
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
