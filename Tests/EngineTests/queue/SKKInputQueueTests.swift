//
//  SKKInputQueueTests.swift
//  BackendTests
//
//  Created by mzp on 2025/05/30.
//

import Testing
@testable internal import AquaSKKEngine
internal import AquaSKKTesting

let converter: RomanKanaConverterImpl = {
    let converter = RomanKanaConverterImpl.shared()
    let bundle = Bundle(for: EngineBundle.self)
    let resource = TestingResource(bundle: bundle)
    let path = try! resource.path("kana-rule.conf", writable: false)
    converter.initialize(from: path)
    return converter
}()

// FIXME: RomanKanaConverterImplの初期化をConcurrency対応にしてMainActorを外す
@MainActor struct SKKInputQueueTesting {
    let observer = TestInputQueueObserverImpl()
    let queue = SKKInputQueueImpl()

    init() throws {
        _ = converter
        queue.observer = observer
    }

    @Test func vowel() {
        queue.addChar(character: "a", direct: false)
        #expect(observer.isEqual(fixed: "あ", queue: ""))
    }

    @Test func consonant() {
        queue.addChar(character: "k", direct: false)
        #expect(observer.isEqual(fixed: "", queue: "k"))
        queue.addChar(character: "y", direct: false)
        #expect(observer.isEqual(fixed: "", queue: "ky"))
        queue.removeChar()
        #expect(observer.isEqual(fixed: "", queue: "k"))
        queue.addChar(character: "i", direct: false)
        #expect(observer.isEqual(fixed: "き", queue: ""))
    }

    @Test func terminate() {
        queue.addChar(character: "n", direct: false)
        #expect(observer.isEqual(fixed: "", queue: "n"))
        queue.terminate()
        #expect(observer.isEqual(fixed: "ん", queue: ""))
    }

    @Test func redundant() {
        queue.addChar(character: "o", direct: false)
        queue.addChar(character: "w", direct: false)
        queue.addChar(character: "s", direct: false)
        queue.addChar(character: "a", direct: false)
        #expect(observer.isEqual(fixed: "おさ", queue: ""))
    }
}
