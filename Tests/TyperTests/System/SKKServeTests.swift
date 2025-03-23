//
//  SKKServeTests.swift
//  TyperTests
//
//  Created by mzp on 2025/03/22.
//

import AquaSKKService
import Testing
internal import AquaSKKTesting
@_spi(Testing) internal import AquaSKKBackend

struct SKKServeTests {
    @Test func lanuch() async {
        let session = Typer.Session()

        await session.run { _ in
            let skkClient = SKKProxyDictionary()
            try! await skkClient.initialize(host: "localhost", port: 11178)

            let suite = await skkClient.find(entry: SKKEntry("きょう", ""))
            #expect(suite == nil)
        }
    }
}
