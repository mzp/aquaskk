//
//  SKKCompleterTests.swift
//  BackendTests
//
//  Created by mzp on 2025/05/29.
//

import Testing
internal import AquaSKKEngine
internal import AquaSKKTesting

class TestBuddy: SKKCompleterBuddyProtcol {
    func completerQueryString() -> String {
        query
    }

    func completerUpdate(entry: String) {
        self.entry = entry
    }

    var entry: String = ""
    var query: String = ""

    init() {}
}

struct SKKCompleterTests {
    @Test func completion() async throws {
        let bundle = Bundle(for: EngineBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("skk-jisyo.utf8", writable: false)

        let backend = SKKBackendImpl.shared()
        await backend.initialize(path: path, configurations: [])

        let buddy = TestBuddy()
        let completer = SKKCompleterImpl(buddyProtocol: buddy)
        buddy.query = "ほかん"
        #expect(completer.execute(limit: 0) == true)
        #expect(buddy.entry == "ほかん1")
        completer.next()
        completer.next()
        #expect(buddy.entry == "ほかん3")

        backend.register(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate())
        buddy.query = "とぐる"
        #expect(completer.execute(limit: 0) == true)
        #expect(buddy.entry == "とぐるほかん")

        backend.remove(entry: SKKEntry("とぐるほかん", ""), candidate: SKKCandidate())
        #expect(completer.execute(limit: 0) == false)
    }
}
