//
//  NumericConverterTests.swift
//  UITests
//
//  Created by mzp on 9/14/24.
//

import Testing
@testable internal import AquaSKKBackend

struct NumericConverterTests {
    /// 数値変換の対象外
    @Test func badFormat() {
        let converter = NumericConverter()
        let result = converter.setup("abc")
        #expect(result == false)
        #expect(converter.originalKey == "abc")
        #expect(converter.normalizedKey == "abc")
    }

    /// 数値変換対象
    @Test func good() {
        let converter = NumericConverter()
        let result = converter.setup("0-1-2-1234-4-1234-34")

        #expect(result == true)
        #expect(converter.normalizedKey == "#-#-#-#-#-#-#")

        var candidate = SKKCandidate("#0-#1-#2-#3-#4-#5-#9", true)
        converter.apply(candidate: &candidate)
        #expect(String(candidate.variant) == "0-１-二-千二百三十四-4-壱阡弐百参拾四-３四")
    }
}
