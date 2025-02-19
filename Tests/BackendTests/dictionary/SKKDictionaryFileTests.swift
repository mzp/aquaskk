//
//  SKKDictionaryFileTests.swift
//  UITests
//
//  Created by mzp on 2/17/25.
//

import Testing
@testable internal import AquaSKKBackend

struct SKKDictionaryFileImplTests {
    let kOkuriAri: [SKKDictionaryEntryImpl] = [
        .init(entry: "うけとt", value: "/受け取/受取/"),
        .init(entry: "いあw", value: "/居合/"),
    ]
    let kOkuriNasi: [SKKDictionaryEntryImpl] = [
        .init(entry: "かんじ", value: "/漢字/官寺/寛治/"),
        .init(entry: "かいはつ", value: "/開発/"),
    ]

    @Test func isEmpty() {
        let file = SKKDictionaryFileImpl()
        #expect(file.isEmpty() == true)
        file.okuriNasi = kOkuriNasi
        #expect(file.isEmpty() == false)
    }

    @Test func sort() {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = kOkuriAri
        file.okuriNasi = kOkuriNasi
        file.sort()

        #expect(file.okuriAri == kOkuriAri.reversed())
        #expect(file.okuriNasi == kOkuriNasi.reversed())
    }

    @Test func persist() async throws {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = kOkuriAri
        file.okuriNasi = kOkuriNasi
        try file.save(path: "dict.file")

        file.okuriAri.removeAll()
        file.okuriNasi.removeAll()

        try await file.load(path: "dict.file")
        #expect(file.okuriAri == kOkuriAri)
        #expect(file.okuriNasi == kOkuriNasi)
    }

    @Test func save() async throws {
        let file = SKKDictionaryFileImpl()
        file.okuriAri = kOkuriAri
        file.okuriNasi = kOkuriNasi
        let uuid = UUID().uuidString
        try file.save(path: "\(uuid).file")
    }
}
