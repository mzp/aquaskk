//
//  SKKSelectorTestirg.swift
//  BackendTests
//
//  Created by mzp on 2025/03/01.
//

import Testing
internal import AquaSKKTesting
@testable internal import AquaSKKBackend
@testable internal import AquaSKKEngine

class EngineBundle {}

struct SKKSelectorTestirg {
    init() async throws {
        let bundle = Bundle(for: EngineBundle.self)
        let resource = TestingResource(bundle: bundle)
        let testJisyoPath = try resource.path("SKK-JISYO.TEST", writable: false)

        await SKKBackendImpl.shared().initialize(path: testJisyoPath, configurations: [
            .init(type: .common, location: testJisyoPath),
        ])
    }

    @Test func main() async throws {
        let buddy = MockSelectorBuddyImpl(entry: "かんじ", okuri: "")
        let selector = SKKSelectorImpl(buddy: buddy, presenter: NullCandidateWindow())
        #expect(selector.execute(inlineCount: 3) == true)

        #expect(String(buddy.current) == "漢字")
    }
}
