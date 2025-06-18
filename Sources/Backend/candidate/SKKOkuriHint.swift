//
//  SKKOkuriHint.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/05/18.
//

import Foundation

public struct SKKOkuriHint {
    public var okuri: String
    public var candidates: [SKKCandidate]

    public init(okuri: String, candidates: [SKKCandidate]) {
        self.okuri = okuri
        self.candidates = candidates
    }
}
