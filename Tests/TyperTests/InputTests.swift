//
//  InputTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import Testing

@MainActor struct InputTests {
    @Test func hiragana() {
        let typer = Typer()
        typer.type(text: "aiueo")
        #expect(typer.text == "あいうえお")
        #expect(typer.markedText == "")
    }

    @Test func katakana() {
        let typer = Typer()
        typer.type(text: "qaiueo")
        #expect(typer.text == "アイウエオ")
        #expect(typer.markedText == "")
    }

    @Test func fullWidthLatinAlphabet() {
        let typer = Typer()
        typer.type(text: "Laiueo")
        #expect(typer.text == "ａｉｕｅｏ")
        #expect(typer.markedText == "")
    }
}
