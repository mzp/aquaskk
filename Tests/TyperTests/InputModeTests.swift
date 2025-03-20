//
//  InputModeTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AppKit
import Testing
internal import AquaSKKBackend

struct InputMenuTests {
    @Test("event", arguments: [
        ("com.apple.inputmethod.Japanese.Hiragana", SKKInputMode.HirakanaInputMode, "あいうえお"),
        ("com.apple.inputmethod.Japanese.Katakana", SKKInputMode.KatakanaInputMode, "アイウエオ"),
        ("com.apple.inputmethod.Japanese.HalfWidthKana", SKKInputMode.Jisx0201KanaInputMode, "ｱｲｳｴｵ"),
        ("com.apple.inputmethod.Japanese.FullWidthRoman", SKKInputMode.Jisx0208LatinInputMode, "ａｉｕｅｏ"),
    ]) func switchByMenu(modeIdentifier: String, inputMode: SKKInputMode, expected: String) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Roman")

            await typer.setValue(modeIdentifier)

            // 2nd call does nothing
            await typer.setValue(modeIdentifier)
            #expect(typer.inputMode == inputMode)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == expected)
        }
    }

    func switchByMenu_Ascii() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Roman")
            await typer.setValue("com.apple.inputmethod.Roman")
            let handled = await typer.handle(event: .init(characters: "a"))
            #expect(handled == false)
        }
    }

    @Test func latin() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(character: "l", keycode: 35)
            #expect(typer.modeIdentifier == "com.apple.inputmethod.Roman")
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

    @Test("toggleKana", arguments: [
        ("com.apple.inputmethod.Japanese.Hiragana", "あいうえお", "アイウエオ"),
        ("com.apple.inputmethod.Japanese.Katakana", "アイウエオ", "あいうえお")
    ]) func toggleKana(identifier: String, primary: String, secondary: String) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue(identifier)
            await typer.handle(event: .toggleKana)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == secondary)
            typer.clear()
            await typer.handle(event: .toggleKana)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == primary)
        }
    }

    @Test func toggleKana_Jis0201Kana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Japanese.HalfWidthKana")
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "ｱｲｳｴｵ")
            typer.clear()
            await typer.handle(event: .toggleKana)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "あいうえお")
            typer.clear()
            await typer.handle(event: .toggleKana)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "アイウエオ")
        }
    }

    @Test("toggleJisx0201Kana", arguments: [
        "com.apple.inputmethod.Japanese.Hiragana",
        "com.apple.inputmethod.Japanese.Katakana"
    ]) func toggleJisx0201Kana(identifier: String) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue(identifier)
            await typer.handle(event: .toggleJisx0201Kana)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == "ｱｲｳｴｵ")
            typer.clear()
        }
    }
}
