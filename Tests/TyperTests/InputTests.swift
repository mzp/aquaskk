//
//  InputTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import AppKit
import Testing

struct InputTests {
    @Test func hiragana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "あいうえお")
            #expect(typer.markedText == "")
        }
    }

    @Test func katakana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "qaiueo")
            #expect(typer.insertedText == "アイウエオ")
            #expect(typer.markedText == "")
        }
    }

    @Test func fullWidthLatinAlphabet() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Laiueo")
            #expect(typer.insertedText == "ａｉｕｅｏ")
            #expect(typer.markedText == "")
        }
    }

    @Test func yank() async {
        let session = Typer.Session()

        await session.run { typer in
            typer.clipboard = "HELLO"
            await typer.type(text: "/hello ")
            await typer.type(text: "y", modifiers: [.control])

            #expect(typer.markedText == "[登録：hello]HELLO")
        }
    }
}
