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

@Suite(.serialized) struct SKKServeTests {
    @Test func lanuch() async {
        let session = Typer.Session()
        await session.run { typer in
            typer.preference { defaults in
                defaults.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
                defaults.set(11178, forKey: SKKUserDefaultKeys.skkserv_port)
            }

            let skkClient = SKKProxyDictionary()
            try! await skkClient.initialize(host: "localhost", port: 11178)
            var suite = await skkClient.find(entry: SKKEntry("きょう", ""))
            #expect(suite != nil)
//            let candidates = suite.candidates
//            #expect(String(candidates[0].variant) == "今日")

            #expect(await skkClient.queryVersion() == "AquaSKKServer1.0 ")
            #expect(await skkClient.queryHost() == "127.0.0.1:0.0.0.0: ")
        }

        await session.run { typer in
            typer.preference { defaults in
                defaults.set(false, forKey: SKKUserDefaultKeys.enable_skkserv)
            }
            let skkClient = SKKProxyDictionary()
            try! await skkClient.initialize(host: "localhost", port: 11178)

            let suite = await skkClient.find(entry: SKKEntry("きょう", ""))
            // #expect(suite == nil)
        }
    }
}
