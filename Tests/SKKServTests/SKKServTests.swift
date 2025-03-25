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
    func updatePreference(perform: (AISUserDefaults) -> Void) {
        let proxy = SKKServerProxy()
        let configuration = try! BundledServerConfiguration(bundle: Bundle.main)
        let defaults = AISUserDefaults(serverConfiguration: configuration)
        perform(defaults)
        defaults.saveChanges()
        proxy.reloadUserDefaults()
    }

    @Test func launch() async throws {
        // launch
        updatePreference { defaults in
            defaults.standard.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
            defaults.standard.set(11178, forKey: SKKUserDefaultKeys.skkserv_port)
        }
        try await Task.sleep(for: .milliseconds(50))

        // query
        let skkClient = SKKProxyDictionary()
        try! await skkClient.initialize(host: "localhost", port: 11178)
        var suite = try #require(await skkClient.find(entry: SKKEntry("きょう", "")))
        let candidates = suite.candidates
        #expect(String(candidates[0].variant) == "今日")

        #expect(await skkClient.queryVersion() == "AquaSKKServer1.0 ")
        #expect(await skkClient.queryHost() == "127.0.0.1:0.0.0.0: ")

        // shutdown
        updatePreference { defaults in
            defaults.standard.set(false, forKey: SKKUserDefaultKeys.enable_skkserv)
        }
        try await Task.sleep(for: .milliseconds(50))

        let newClient = SKKProxyDictionary()
        #expect(await newClient.queryHost() == nil)
    }
}
