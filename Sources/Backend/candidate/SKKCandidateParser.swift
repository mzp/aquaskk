//
//  SKKCandidateParser.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/05/12.
//

import AquaSKKLogging
import Foundation
import OSLog

class SKKCandidateEntryParsers: SKKParsersBase {
    func many<T>(separateBy separator: String, parser: () throws -> T) throws -> [T] {
        return try many {
            let value = try parser()
            _ = try oneOf(separator)
            return value
        }
    }

    func token(head: String, tail: String) throws -> String {
        do {
            let head = try noneOf(head)
            let tail = try many(parser: {
                try noneOf(tail)
            })
            return String([head] + tail)
        } catch _ as UnexpectedTokenError {
            return ""
        }
    }

    func candidate() throws -> SKKCandidate {
        let word = try token(head: "/[", tail: "/")
        return SKKCandidate(std.string(word), true)
    }

    func hintCandiadte() throws -> [SKKCandidate] {
        _ = try expect(character: "/")
        return try many(separateBy: "/") {
            let word = try token(head: "/[]", tail: "/]")
            return SKKCandidate(std.string(word), true)
        }
    }

    func hint() throws -> SKKOkuriHint {
        _ = try expect(character: "[")
        let entry = try token(head: "/[]", tail: "/")

        let candidates = try attempt {
            _ = try expect(character: "/")
            return try many(separateBy: "/") {
                let word = try token(head: "/[]", tail: "/]")
                return SKKCandidate(std.string(word), true)
            }
        }

        _ = try expect(character: "]")

        var hint = SKKOkuriHint(
            okuri: entry,
            candidates: .init()
        )

        if let candidates = candidates {
            for candidate in candidates {
                guard !candidate.IsEmpty()
                else {
                    continue
                }
                hint.candidates.append(candidate)
            }
        }

        return hint
    }

    func entry() throws -> ([SKKCandidate], [SKKOkuriHint]) {
        _ = try expect(character: "/")
        let candidates: [SKKCandidate] = try many(separateBy: "/") {
            try candidate()
        }.filter {
            !$0.IsEmpty()
        }
        let hints: [SKKOkuriHint] = try many(separateBy: "/") {
            try hint()
        }.filter {
            $0.okuri.isEmpty != true ||
                !$0.candidates.isEmpty
        }

        return (candidates, hints)
    }
}

public class SKKCandidateParser {
    public var candidates: [SKKCandidate] = []
    public var hints: [SKKOkuriHint] = []

    public init() {}

    public func parse(_ string: String) {
        candidates = []
        hints = []

        let parsers = SKKCandidateEntryParsers(source: string)

        do {
            (candidates, hints) = try parsers.entry()
        } catch {
            Logger.skkBackend.error("[\(#fileID, privacy: .public):\(#function, privacy: .public)] \(error.localizedDescription, privacy: .private)")
        }
    }
}
