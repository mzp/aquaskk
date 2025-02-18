//
//  SKKDictionaryFileTests.swift
//  UITests
//
//  Created by mzp on 2/17/25.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKDictionaryFileImplTests {
    let okuriAri: [SKKDictionaryEntryImpl] = [
        .init(entry: "うけとt", value: "/受け取/受取/"),
        .init(entry: "いあw", value: "/居合/"),
    ]
    let okuriNasi: [SKKDictionaryEntryImpl] = [
        .init(entry: "かんじ", value: "/漢字/官寺/寛治/"),
        .init(entry: "かいはつ", value: "/開発/"),
    ]

    @Test func isEmpty() {
        let file = SKKDictionaryFileImpl()
        #expect(file.isEmpty() == true)
        file.okuriNasi = okuriNasi
        #expect(file.isEmpty() == false)
    }

    @Test func sort() {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = okuriAri
        file.okuriNasi = okuriNasi
        file.sort()

        #expect(file.okuriAri == okuriAri.reversed())
        #expect(file.okuriNasi == okuriNasi.reversed())
    }

    @Test func persist() async throws {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = okuriAri
        file.okuriNasi = okuriNasi
        #expect(file.save(path: "dict.file") == true)

        file.okuriAri.removeAll()
        file.okuriNasi.removeAll()

        #expect(await file.load(path: "dict.file") == true)
        #expect(file.okuriAri == okuriAri)
        #expect(file.okuriNasi == okuriNasi)
    }

    @Test func save() async throws {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = okuriAri
        file.okuriNasi = okuriNasi
        let uuid = UUID().uuidString
        #expect(file.save(path: "\(uuid).file") == true)
    }
}
