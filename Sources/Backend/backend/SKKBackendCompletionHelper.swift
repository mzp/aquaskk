//
//  SKKBackendCompletionHelper.swift
//  AquaSKKBackend
//
//  Created by mzp on 2025/02/23.
//

import Foundation

class SKKBackendCompletionHelper: SKKCompletionHelperProtocol {
    var entry: String
    var minimumLength: Int
    var limit: Int
    var result: [String]
    private var found: Set<String>

    init(entry: String, minimumLength: Int, limit: Int) {
        self.entry = entry
        self.minimumLength = minimumLength
        self.limit = limit
        result = []
        found = Set([entry])
    }

    var canContinue: Bool {
        return limit == 0 || result.count < limit
    }

    var needsCheck: Bool {
        entry.count < minimumLength
    }

    func add(completion: String) {
        guard canContinue else {
            return
        }
        if needsCheck && completion.count <= minimumLength {
            return
        }
        if found.contains(completion) {
            return
        }
        found.insert(completion)
        result.append(completion)
    }
}
