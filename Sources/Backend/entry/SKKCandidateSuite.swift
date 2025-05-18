//
//  SKKCandidateSuite.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/05/17.
//

import Foundation

extension SKKCandidate: Equatable {}

public struct SKKCandidateSuite {
    public var candidates: [SKKCandidate]
    public var hints: [SKKOkuriHint]

    public init() {
        candidates = []
        hints = []
    }

    public init(string: String) {
        var tmp = SKKCandidateSuite()
        tmp.parse(string: string)
        self = tmp
    }

    // MARK: - Candidates

    public mutating func add(candidate: SKKCandidate) {
        guard !candidates.contains(candidate) else {
            return
        }
        candidates.append(candidate)
    }

    public mutating func update(candidate: SKKCandidate) {
        candidates.removeAll(where: { $0 == candidate })
        candidates.insert(candidate, at: 0)
    }

    public mutating func remove(candidate: SKKCandidate) {
        candidates.removeAll(where: { $0 == candidate })

        var newHints = [SKKOkuriHint]()
        for hint in hints {
            var content = Array(hint.second)
            content.removeAll(where: {
                $0.variant == candidate.variant
            })
            if !content.isEmpty {
                var newHint = newSKKOkuriHint()
                newHint.first = hint.first
                for item in content {
                    newHint.second.push_back(item)
                }
                newHints.append(newHint)
            }
        }
        hints = newHints
    }

    // MARK: - Hint

    public mutating func add(hint: SKKOkuriHint) {
        if let index = hints.firstIndex(where: {
            $0.first == hint.first
        }) {
            for item in hint.second {
                hints[index].second.push_back(item)
            }
        } else {
            hints.append(hint)
        }
    }

    public mutating func add(hints: [SKKOkuriHint]) {
        for item in hints {
            add(hint: item)
        }
    }

    public mutating func update(hint: SKKOkuriHint) {
        // hint.second[0]以外は見ていない？
        guard let candidate = hint.second.first else {
            return
        }
        update(candidate: candidate)

        if let index = hints.firstIndex(where: {
            $0.first == hint.first
        }) {
            var content = Array(hints[index].second)
            content.removeAll(where: {
                $0 == candidate
            })
            content.insert(candidate, at: 0)

            hints[index].second.clear()
            for item in content {
                hints[index].second.push_back(item)
            }
        } else {
            hints.insert(hint, at: 0)
        }
    }

    // MARK: - Suite

    public mutating func add(suite: SKKCandidateSuite) {
        for item in suite.candidates {
            add(candidate: item)
        }
        for item in suite.hints {
            add(hint: item)
        }
    }

    func findOkuriStrictly(okuri: String) -> SKKCandidateSuite? {
        guard let hint = hints.first(where: {
            String($0.first) == okuri
        }) else {
            return nil
        }
        var suite = SKKCandidateSuite()
        for item in hint.second {
            suite.add(candidate: item)
        }
        return suite
    }

    public var isEmpty: Bool {
        candidates.isEmpty
    }

    public mutating func clear() {
        candidates.removeAll()
        hints.removeAll()
    }

    // MARK: - Parsing

    public mutating func parse(string: String) {
        let parser = SKKCandidateParser()
        parser.parse(string)

        candidates = parser.candidates
        hints = parser.hints
    }

    func format(candidates: [SKKCandidate], excludeAvoidStudy: Bool) -> String {
        candidates.compactMap { candidate in
            if excludeAvoidStudy && candidate.AvoidStudy() {
                return nil
            }
            return String(candidate.ToString())
        }.joined(separator: "/")
    }

    public func string(excludeAvoidStudy: Bool = false) -> String {
        var str = "/"

        str += format(candidates: candidates, excludeAvoidStudy: excludeAvoidStudy)

        str += hints.map { hint in
            let entry = String(hint.first)
            let hints = format(candidates: Array(hint.second), excludeAvoidStudy: excludeAvoidStudy)
            return "/[\(entry)/\(hints)/]"
        }.joined()

        if !str.isEmpty {
            str += "/"
        }

        return str
    }
}
