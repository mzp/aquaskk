//
//  EditorTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/06.
//

import Testing

struct EditorTests {
    // MARK: - Primary
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

    // MARK: - Composing

    @Test func composing() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            #expect(typer.markedText == "▽きょう")
            #expect(typer.markedTextRange == .init(location: 4, length: 0))

            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText == "▽きょ")
        }
    }

    @Test func toggleKana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Aiueo")
            await typer.handle(event: .toggleKana)
            #expect(typer.insertedText == "アイウエオ")
        }
    }
    @Test func toggleJisx0201Kana() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Aiueo")
            await typer.handle(event: .toggleJisx0201Kana)
            #expect(typer.insertedText == "ｱｲｳｴｵ")
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
