//
//  EditorTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/06.
//

import Testing

struct EditorTests {
    // MARK: - Primary

    @Test func primary() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "kyou")
            #expect(typer.insertedText == "きょう")
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

    @Test func abbrev() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Japanese.Hiragana")
            await typer.type(text: "/skk")
            #expect(typer.markedText == "▽skk")
        }
    }

    // MARK: - Composing

    @Test func composing() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            #expect(typer.markedText == "▽きょう")
            #expect(typer.markedTextRange == .init(location: 4, length: 0))
        }
    }

    // MARK: - Candidate

    @Test func candidate() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")
        }
    }

    // TODO: - Okuri Editor

    // MARK: - Entry remove Editor

    @Test func remove() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")
            await typer.type(text: "X", modifiers: [.shift])
            #expect(typer.markedText == "きょう /今日/ を削除しますか？(yes/no) ")
        }
    }
}
