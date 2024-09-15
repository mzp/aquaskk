//
//  LocalUserDictionary.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/15/24.
//

import Foundation


class LocalUserDictionary {
    private var path: String? = nil
    var privateMode: Bool = false

    func initialize(path: String) {
        if let oldPath = self.path {
            if path == oldPath {
                return
            }
            save(force: true)
        }
        self.path = path

    }

    func save(force: Bool) {

    }

    func find(entry: SKKEntry, to suite: inout SKKCandidateSuite) {
    }

    func register(entry: SKKEntry, candidate: SKKCandidate) {}

    func remove(entry: SKKEntry, candidate: SKKCandidate) {}

    func complete(helper: SKKCompletionHelper) {}
//    void Complete(SKKCompletionHelper &helper);

    func reverseLookup(candidate: String) -> String {
        ""
    }
}
