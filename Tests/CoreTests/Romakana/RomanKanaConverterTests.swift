//
//  RomanKanaConverterTests.swift
//  CoreTests
//
//  Created by mzp on 8/12/24.
//

@testable import AquaSKKCore
import Testing

struct RomanKanaConverterTests {
    func romanKana() throws -> RomanKanaConverter {
        let path = try CoreTesting.shared.path("kana-rule.conf")
        return try RomanKanaConverter(path: path)
    }

    @Test("input mode", arguments: [
        (SKKInputMode.HirakanaInputMode, "あ"),
    ]) func inputMode(inputMode: SKKInputMode, expect: String) throws {
        let romanKana = try romanKana()
        let result = try #require(romanKana.convert("a", inputMode: inputMode))
        #expect(result.next == "")
        #expect(result.intermediate == "")
        #expect(result.output == expect)
    }

    @Test("convert", arguments: [
        ("kgya", "ぎゃ"),
        ("gyagyugyo", "ぎゃぎゅぎょ"),
        ("kanji", "かんじ"),

        ("kyl", "l"),
        ("co", "お"),
        ("k1", "1"),

        ("k1234gya", "1234ぎゃ"),
        ("chho", "ほ"),
        ("pmpo", "ぽ"),

        ("/", "/"),
        ("'", "'"),
        (",", "、"),
        (" ", " "),
        ("#", "＃"), // FULLWIDTH NUMBER SIGN

        ("z,", "‥"), // TWO DOT LEADER
        ("z ", "　"), // IDEOGRAPHIC SPACE
        ("z\\", "￥"), // FULLWIDTH YEN SIGN
    ]) func convert(input: String, expect: String) throws {
        let romanKana = try romanKana()
        let result = try #require(romanKana.convert(input, inputMode: .HirakanaInputMode))

        #expect(result.next == "")
        #expect(result.output == expect)
    }

    @Test("convert", arguments: [
        ("c", "c"),
        ("pmp", "p"),
    ]) func next(input: String, expect: String) throws {
        let romanKana = try romanKana()
        let result = try #require(romanKana.convert(input, inputMode: .HirakanaInputMode))
        #expect(result.next == expect)
        #expect(result.output == "")
    }

    @Test func gg() throws {
        let romanKana = try romanKana()
        let result = try #require(romanKana.convert("gg", inputMode: .HirakanaInputMode))

        #expect(result.next == "g")
        #expect(result.output == "っ")
    }

    @Test func patch() throws {
        let romanKana = try romanKana()
        let path = try CoreTesting.shared.path("period.rule")

        let original = try #require(romanKana.convert(".", inputMode: .HirakanaInputMode))
        #expect(original.output == "。")
        try romanKana.append(path: String(path))

        let patched = try #require(romanKana.convert(".", inputMode: .HirakanaInputMode))
        #expect(patched.output == "．")
    }
}
