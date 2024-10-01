//
//  DictionaryLoaderTests.swift
//  UITests
//
//  Created by mzp on 9/30/24.
//

import Testing
internal import AquaSKKTesting
@testable internal import AquaSKKBackend

class TestLoader: DictionaryLoader {
    var state: Bool = false
    var path: String = ""

    override func needsUpdate() -> Bool {
        return state
    }

    override func filePath() -> String {
        return path
    }

    override func interval() -> TimeInterval {
        1
    }

    override func timeout() -> TimeInterval {
        1
    }
}

class TestObserver: DictionaryLoaderDelegate {
    var file: DictionaryFile?
    var notified: Bool = false

    func dictionaryLoaderDidUpdate(file: DictionaryFile) {
        self.file = file
        notified = true
    }

    func clear() {
        notified = false
    }
}

struct TestLoaderAction {
    var comment: String // コメント
    var state: Bool // 更新が必要か
    var path: String // ファイルパス
    var notified: Bool // 通知されたかどうか
    var empty: Bool // ファイルが空かどうか
}

struct DictionaryLoaderTests {
    let path: String

    init() throws {
        let bundle = Bundle(for: BackendBundle.self)
        let resource = TestingResource(bundle: bundle)
        path = try resource.path("SKK-JISYO.TEST")
    }

    func run(scenario: [TestLoaderAction]) throws {
        let loader = TestLoader()
        let observer = TestObserver()
        loader.delegate = observer

        for action in scenario {
            loader.state = action.state
            loader.path = action.path
            observer.clear()

            loader.run()

            #expect(observer.notified == action.notified)
            let file = try #require(observer.file)
            #expect(file.isEmpty == action.empty)
        }
    }

    @Test func localFile() throws {
        try run(scenario: [
            .init(comment: "初期ロード", state: false, path: path, notified: true, empty: false),
            .init(comment: "未更新", state: false, path: path, notified: false, empty: false),
            .init(comment: "更新通知", state: true, path: path, notified: true, empty: false),
        ])
    }

    @Test func download() throws {
        try run(scenario: [
            .init(comment: "初期ロード", state: false, path: "/dev/null", notified: true, empty: true),
            .init(comment: "空ファイル通知", state: false, path: path, notified: true, empty: true),
            .init(comment: "更新通知", state: true, path: path, notified: true, empty: false),
            .init(comment: "未更新", state: false, path: path, notified: false, empty: false),
        ])
    }
}
