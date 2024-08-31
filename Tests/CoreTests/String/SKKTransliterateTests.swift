//
//  SKKTransliterateTests.swift
//  UITests
//
//  Created by mzp on 8/31/24.
//

import AquaSKKCore
import Testing

struct SKKTransliterateTests {
    @Test func hirakana() {
        var result: std.string = ""
        SKKTransliterate.hirakana_to_katakana("あいうえお", &result)
        #expect(result == "アイウエオ")

        SKKTransliterate.hirakana_to_jisx0201_kana("あいうえお", &result)
        #expect(result == "ｱｲｳｴｵ")

        SKKTransliterate.hirakana_to_roman("あいうえお", &result)
        #expect(result == "aiueo")
    }

    @Test func katakana() {
        var result: std.string = ""
        SKKTransliterate.katakana_to_hirakana("アイウエオ", &result)
        #expect(result == "あいうえお")

        SKKTransliterate.katakana_to_jisx0201_kana("アイウエオ", &result)
        #expect(result == "ｱｲｳｴｵ")

        SKKTransliterate.katakana_to_roman("アイウエオ", &result)
        #expect(result == "aiueo")
    }

    @Test func jisx0201Kana() {
        var result: std.string = ""
        SKKTransliterate.jisx0201_kana_to_hirakana("ｱｲｳｴｵ", &result)
        #expect(result == "あいうえお")

        SKKTransliterate.jisx0201_kana_to_katakana("ｱｲｳｴｵ", &result)
        #expect(result == "アイウエオ")

        SKKTransliterate.jisx0201_kana_to_roman("ｱｲｳｴｵ", &result)
        #expect(result == "aiueo")
    }

    @Test func latin() {
        var result: std.string = ""
        SKKTransliterate.ascii_to_jisx0208_latin("aiueo", &result)
        #expect(result == "ａｉｕｅｏ")
        SKKTransliterate.jisx0208_latin_to_ascii("ａｉｕｅｏ", &result)
        #expect(result == "aiueo")
    }
}
