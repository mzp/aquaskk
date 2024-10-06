//
//  DictionaryKeeperTests.swift
//  UITests
//
//  Created by mzp on 10/1/24.
//

import Testing
@testable internal import AquaSKKBackend
internal import AquaSKKTesting

class MockLoader: DictionaryLoader {
    var path: String
    init(path: String) {
        self.path = path
    }
    override func needsUpdate() -> Bool {
        true
    }
    override func interval() -> TimeInterval {
        0.1
    }
    override func timeout() -> TimeInterval {
        1
    }
    override func filePath() -> String {
        path
    }
}

struct DictionaryKeeperTests {
    let paths: [DictionaryKeeper.Encoding: String] = [
        .utf8: "SKK-JISYO.TEST.UTF8",
        .eucjp: "SKK-JISYO.TEST"
    ]
    func create(encoding: DictionaryKeeper.Encoding)throws -> DictionaryKeeper {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path(paths[encoding]!)
        
        let loader = MockLoader(path: path)
        let keeper = DictionaryKeeper(encoding: encoding)
        
        keeper.initialize(loader: loader)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.2))
        return keeper
    }
    
    @Test(arguments: [
        DictionaryKeeper.Encoding.utf8, .eucjp
    ])
    func okuriNasi(encoding: DictionaryKeeper.Encoding) throws {
        let keeper = try create(encoding: encoding)
        let words = keeper.findOkuriNasi(query: "かんじ")
        #expect(words.contains("/官寺"))
    }
    
    @Test(arguments: [
        DictionaryKeeper.Encoding.utf8, .eucjp
    ]) func okuriAri(encoding: DictionaryKeeper.Encoding) throws {
        let keeper = try create(encoding: encoding)
        let words = keeper.findOkuriAri(query: "よi")
        #expect(words.contains("/良"))
    }
    
    @Test(arguments: [
        DictionaryKeeper.Encoding.utf8, .eucjp
    ]) func reverseLookup(encoding: DictionaryKeeper.Encoding) throws {
        let keeper = try create(encoding: encoding)
        let reading = keeper.reverseLookup(candidate: "官寺")
        #expect(reading == "かんじ")
    }
    
    @Test(arguments: [
        DictionaryKeeper.Encoding.utf8, .eucjp
    ]) func completion(encoding: DictionaryKeeper.Encoding) throws {
        let keeper = try create(encoding: encoding)
        let mock : MockCompletionHelper = MockCompletionHelper.newInstance()
        mock.Initialize("かん")
        var helper: CompletionHelper = mock.bridge()
        keeper.complete(helper: &helper)
        let first = mock.Result().first
        #expect(first == "かんじ")
    }
}
