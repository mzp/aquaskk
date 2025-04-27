//
//  ToggleKanaTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import Testing

struct ToggleKanaTests {
    @Test(.disabled("WIP")) func composing_toggleKana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Aiueo")
            await typer.handle(event: .toggleKana)
            #expect(typer.insertedText == "アイウエオ")
        }
    }

    @Test(.disabled("WIP")) func composing_toggleJisx0201Kana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Aiueo")
            await typer.handle(event: .toggleJisx0201Kana)
            #expect(typer.insertedText == "ｱｲｳｴｵ")
        }
    }

    @Test(.disabled("WIP")) func asciiEntry() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "/abc")
            await typer.handle(event: .toggleJisx0201Kana)
            #expect(typer.insertedText == "ａｂｃ")

            typer.clear()
            await typer.type(text: "aiu")
            #expect(typer.insertedText == "あいう")
        }
    }

    @Test("toggleKana", arguments: [
        ("com.apple.inputmethod.Japanese.Hiragana", "あいうえお", "アイウエオ"),
        ("com.apple.inputmethod.Japanese.Katakana", "アイウエオ", "あいうえお")
    ]) func transliterationKana(identifier: String, primary: String, secondary: String) async {
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

    @Test func transliterationKana_Jis0201Kana() async {
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
    ]) func transliterationJisx0201Kana(identifier: String) async {
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
