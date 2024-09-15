//
//  DictionaryFileTests.swift
//  UITests
//
//  Created by mzp on 9/14/24.
//

import Testing
@testable internal import AquaSKKBackend

struct DictionaryFileTests {
    let okuriAri = [
        DictionaryEntry(key: "うけとt", rawEntry: "/受け取/受取/"),
        DictionaryEntry(key: "いあw", rawEntry: "/居合/"),
    ]
    let okuriNasi = [
        DictionaryEntry(key: "かんじ", rawEntry: "/漢字/官寺/寛治/"),
        DictionaryEntry(key: "かいはつ", rawEntry: "/開発/"),
    ]

    @Test func isEmpty() {
        var file = DictionaryFile()
        #expect(file.isEmpty == true)
        file.okuriNasi = okuriNasi
        #expect(file.isEmpty == false)
    }

    @Test func sort() {
        var file = DictionaryFile()
        file.okuriAri = okuriAri
        file.okuriNasi = okuriNasi
        file.sort()

        #expect(file.okuriAri == okuriAri.reversed())
        #expect(file.okuriNasi == okuriNasi.reversed())
    }

    @Test func persist() async throws {
        var file = DictionaryFile()
        file.okuriAri = okuriAri
        file.okuriNasi = okuriNasi
        try file.save(path: "dict.file")

        file.okuriAri.removeAll()
        file.okuriNasi.removeAll()

        try await file.load(path: "dict.file")
        #expect(file.okuriAri == okuriAri)
        #expect(file.okuriNasi == okuriNasi)
    }
}
