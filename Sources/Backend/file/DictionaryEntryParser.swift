//
//  DictionaryEntryParser.swift
//  AquaSKKBackend
//
//  Created by mzp on 2/17/25.
//

let kOkuriAriMark = ";; okuri-ari entries."
let kOkuriNasiMark = ";; okuri-nasi entries."

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
