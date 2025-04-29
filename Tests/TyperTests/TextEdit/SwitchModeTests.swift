//
//  SwitchModeTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AppKit
import Testing
internal import AquaSKKBackend

struct SwitchModeTests {
    @Test func ping() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.handle(event: .ping)
        }
    }

    @Test func hiragana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Roman")
            await typer.handle(event: .skkJmode)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "あいうえお")
            #expect(typer.markedText == "")

            await typer.handle(event: .ping)
            #expect(typer.inputMode == .HirakanaInputMode)
        }
    }

    @Test func katakana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "q")
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "アイウエオ")
            #expect(typer.markedText == "")

            await typer.handle(event: .ping)
            #expect(typer.inputMode == .KatakanaInputMode)
        }
    }

    @Test func latin() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(character: "l", keycode: 35)
            #expect(typer.modeIdentifier == "com.apple.inputmethod.Roman")

            await typer.handle(event: .ping)
            #expect(typer.inputMode == .AsciiInputMode)
        }
    }

    @Test func fullWidthLatinAlphabet() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Laiueo")
            #expect(typer.insertedText == "ａｉｕｅｏ")
            #expect(typer.markedText == "")

            await typer.handle(event: .ping)
            #expect(typer.inputMode == .Jisx0208LatinInputMode)

            await typer.handle(event: .init(characters: "a", modifiers: .capsLock))
            #expect(typer.insertedText == "ａｉｕｅｏＡ")
        }
    }

    @Test("switch by key", arguments: [
        ("l", SKKInputMode.AsciiInputMode),
        ("L", SKKInputMode.Jisx0208LatinInputMode),
        ("Q", SKKInputMode.HirakanaInputMode),
    ]) func kanaEntry(key: String, inputMode: SKKInputMode) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kanji")
            await typer.type(text: key)
            #expect(typer.insertedText == "かんじ")
            #expect(typer.inputMode == inputMode)
        }
    }

    @Test func unknownWord() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kanji   ")
            #expect(typer.markedText == "[登録：かんじ]")
        }
    }

    @Test func abbrev() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Japanese.Hiragana")
            await typer.type(text: "/skk")
            #expect(typer.markedText == "▽skk")
        }
    }

    @Test func enterJapanese() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.handle(event: .enterJapanese)
            #expect(typer.markedText == "▽")
            await typer.type(text: "aiueo")
            #expect(typer.markedText == "▽あいうえお")
        }
    }
}
