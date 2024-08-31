//
//  SKKEncodingTests.swift
//  UITests
//
//  Created by mzp on 8/31/24.
//

import AquaSKKCore
import AquaSKKTesting
import Testing

struct SKKEncodingTests {
    @Test("convert", arguments: [
        "abc",
        "あいうえお",
    ]) func convert(text: String) {
        let utf8 = std.string(text)
        let eucj = testing.jconv.eucj_from_utf8(utf8)
        #expect(SKKEncoding.eucj_from_utf8(utf8) == eucj)
        #expect(SKKEncoding.utf8_from_eucj(eucj) == utf8)

        var result: std.string = ""
        SKKEncoding.convert_utf8_to_eucj(utf8, &result)
        #expect(result == eucj)

        result = ""
        SKKEncoding.convert_eucj_to_utf8(eucj, &result)
        #expect(result == utf8)
    }
}
