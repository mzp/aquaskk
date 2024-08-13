//
//  InputTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import Testing

struct InputTests {
    @Test func hiragana() async {
        let typer = await Typer()
        typer.type(text: "aiueo")
        #expect(typer.text == "あいうえお")
        #expect(typer.markedText == "")
    }

    @Test func katakana() async {
        let typer = await Typer()
        typer.type(text: "qaiueo")
        #expect(typer.text == "アイウエオ")
        #expect(typer.markedText == "")
    }

    @Test func fullWidthLatinAlphabet() async {
        let typer = await Typer()
        typer.type(text: "Laiueo")
        #expect(typer.text == "ａｉｕｅｏ")
        #expect(typer.markedText == "")
    }
}
