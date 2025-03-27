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
    let skkClient: SKKProxyDictionary

    init() async throws {
        // launch
        Self.updatePreference { defaults in
            defaults.standard.set(true, forKey: SKKUserDefaultKeys.enable_skkserv)
            defaults.standard.set(11178, forKey: SKKUserDefaultKeys.skkserv_port)
            defaults.standard.set(false, forKey: SKKUserDefaultKeys.skkserv_localonly)
        }
        try await Task.sleep(for: .milliseconds(50))

        skkClient = SKKProxyDictionary()
        try await skkClient.initialize(host: "localhost", port: 11178)
    }

    static func updatePreference(perform: (AISUserDefaults) -> Void) {
        let proxy = SKKServerProxy()
        let configuration = try! BundledServerConfiguration(bundle: Bundle.main)
        let defaults = AISUserDefaults(serverConfiguration: configuration)
        perform(defaults)
        defaults.saveChanges()
        proxy.reloadUserDefaults()
    }

    @Test func okuriNasi() async throws {
        // query
        var suite = try #require(await skkClient.find(entry: SKKEntry("きょう", "")))
        let candidate = try String(#require(suite.candidates.first).variant)
        #expect(candidate == "今日")
    }

    @Test func okuriAri() async throws {
        var suite = try #require(await skkClient.find(entry: SKKEntry("ころg", "")))
        let candidate = try String(#require(suite.candidates.first).variant)
        #expect(candidate == "転")
    }

    @Test func notFound() async throws {
        var suite = try #require(await skkClient.find(entry: SKKEntry("NOT_EXIST", "")))
        #expect(suite.IsEmpty() == true)
    }

    @Test func query() async throws {
        #expect(await skkClient.queryVersion() == "AquaSKKServer1.0 ")
        #expect(await skkClient.queryHost() == "127.0.0.1:0.0.0.0: ")

        // Completion
        await skkClient.query(command: "4     \n")
        // unknown command
        await skkClient.query(command: "unknown\n")
        await skkClient.queryClose()
    }

    @Test func shutdown() async throws {
        // shutdown
        Self.updatePreference { defaults in
            defaults.standard.set(false, forKey: SKKUserDefaultKeys.enable_skkserv)
        }
        try await Task.sleep(for: .milliseconds(50))

        let newClient = SKKProxyDictionary()
        #expect(await newClient.queryHost() == nil)
    }
}
