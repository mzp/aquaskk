//
//  SKKServTests.swift
//  SKKServTests
//
//  Created by mzp on 2025/03/23.
//

import Testing
internal import AquaSKKTesting
import AquaSKKService
@_spi(Testing) internal import AquaSKKBackend

/// skkservを起動するため、他のテストと並列実行すると結果が不安定になる
/// それを避けるために独立したテストターゲットにした上で直列実行する。
@Suite(.serialized) struct SKKServTests {
    @Test func launch() async throws {
        let proxy = SKKServerProxy()
        let configuration = try! BundledServerConfiguration(bundle: Bundle.main)
        let defaults = AISUserDefaults(serverConfiguration: configuration)
        defaults.standard.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
        defaults.standard.set(11178, forKey: SKKUserDefaultKeys.skkserv_port)
        defaults.saveChanges()
        proxy.reloadUserDefaults()

        let skkClient = SKKProxyDictionary()
        try! await skkClient.initialize(host: "localhost", port: 11178)
        var suite = try #require(await skkClient.find(entry: SKKEntry("きょう", "")))
        let candidates = suite.candidates
        #expect(String(candidates[0].variant) == "今日")

        #expect(await skkClient.queryVersion() == "AquaSKKServer1.0 ")
        #expect(await skkClient.queryHost() == "127.0.0.1:0.0.0.0: ")
    }
}
