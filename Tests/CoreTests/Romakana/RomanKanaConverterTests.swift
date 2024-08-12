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

    @Test func inputMode() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()
        #expect(romanKana.Convert(.HirakanaInputMode, "a", &state) == true)
        #expect(state.next == "")
        #expect(state.output == "あ")

        #expect(romanKana.Convert(.KatakanaInputMode, "a", &state) == true)
        #expect(state.next == "")
        #expect(state.output == "ア")

        #expect(romanKana.Convert(.Jisx0201KanaInputMode, "a", &state) == true)
        #expect(state.next == "")
        #expect(state.output == "ｱ")
    }

    @Test func convert() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, "kgya", &state)
        #expect(state.next == "")
        #expect(state.output == "ぎゃ")

        romanKana.Convert(.HirakanaInputMode, "gyagyugyo", &state)
        #expect(state.next == "")
        #expect(state.output == "ぎゃぎゅぎょ")

        romanKana.Convert(.HirakanaInputMode, "kanji", &state)
        #expect(state.next == "")
        #expect(state.output == "かんじ")
    }

    @Test func next() throws {
        var romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, "gg", &state)
        #expect(state.next == "g")
        #expect(state.output == "っ")

        romanKana.Convert(.HirakanaInputMode, "c", &state)
        #expect(state.next == "c")
        #expect(state.output == "")

        romanKana.Convert(.HirakanaInputMode, "pmp", &state)
        #expect(state.next == "p")
        #expect(state.output == "")
    }

    @Test func confirm() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, "kyl", &state)
        #expect(state.next == "")
        #expect(state.output == "l")

        romanKana.Convert(.HirakanaInputMode, "co", &state)
        #expect(state.next == "")
        #expect(state.output == "お")

        romanKana.Convert(.HirakanaInputMode, "k1", &state)
        #expect(state.next == "")
        #expect(state.output == "1")
    }

    @Test func ignore() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()
        romanKana.Convert(.HirakanaInputMode, "k1234gya", &state)
        #expect(state.next == "")
        #expect(state.output == "1234ぎゃ")

        romanKana.Convert(.HirakanaInputMode, "chho", &state)
        #expect(state.next == "")
        #expect(state.output == "ほ")

        romanKana.Convert(.HirakanaInputMode, "pmpo", &state)
        #expect(state.next == "")
        #expect(state.output == "ぽ")
    }

    @Test func symbols() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, "/", &state)
        #expect(state.next == "")
        #expect(state.output == "/")

        romanKana.Convert(.HirakanaInputMode, "'", &state)
        #expect(state.next == "")
        #expect(state.output == "'")

        romanKana.Convert(.HirakanaInputMode, ",", &state)
        #expect(state.next == "")
        #expect(state.output == "、")

        romanKana.Convert(.HirakanaInputMode, " ", &state)
        #expect(state.next == "")
        #expect(state.output == " ")

        romanKana.Convert(.HirakanaInputMode, "#", &state)
        #expect(state.next == "")
        #expect(state.output == "＃") // FULLWIDTH NUMBER SIGN
    }

    @Test func zPrefix() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, "z,", &state)
        #expect(state.next == "")
        #expect(state.output == "‥") // TWO DOT LEADER

        romanKana.Convert(.HirakanaInputMode, "z ", &state)
        #expect(state.next == "")
        #expect(state.output == "　") // IDEOGRAPHIC SPACE

        romanKana.Convert(.HirakanaInputMode, "z\\", &state)
        #expect(state.next == "")
        #expect(state.output == "￥") // FULLWIDTH YEN SIGN
    }

    @Test func patch() throws {
        let romanKana = try romanKana()
        var state = SKKRomanKanaConversionResult()

        romanKana.Convert(.HirakanaInputMode, ".", &state)
        #expect(state.output == "。")

        let path = try CoreTesting.shared.path("period.rule")
        romanKana.Patch(path)

        romanKana.Convert(.HirakanaInputMode, ".", &state)
        #expect(state.output == "．")
    }
}
