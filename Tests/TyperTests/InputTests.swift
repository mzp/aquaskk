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
        await typer.type(text: "aiueo")
        #expect(await typer.text == "あいうえお")
        #expect(await typer.markedText == "")
        await typer.deactivate()
    }

    @Test func katakana() async {
        let typer = await Typer()
        await typer.type(text: "qaiueo")
        #expect(await typer.text == "アイウエオ")
        #expect(await typer.markedText == "")
        await typer.deactivate()
    }

    @Test func fullWidthLatinAlphabet() async {
        let typer = await Typer()
        await typer.type(text: "Laiueo")
        #expect(await typer.text == "ａｉｕｅｏ")
        #expect(await typer.markedText == "")
        await typer.deactivate()
    }
}
