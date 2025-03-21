//
//  TextComposeTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/06.
//

import Testing

struct TextComposeTests {
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

    @Test("unhandled event", arguments: [
        TyperEvent.skkEnter,
        .skkCancel,
        .skkBackspace,
        .skkDelete,
        .skkLeft,
        .skkRight,
        .skkUp,
        .skkDown
    ]) func unhandle(event: TyperEvent) async {
        let session = Typer.Session()
        await session.run { typer in
            let handled = await typer.handle(event: event)
            #expect(handled == false)
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
            #expect(typer.markedTextRange == .init(location: 3, length: 0))

            await typer.handle(event: .skkLeft)
            #expect(typer.markedTextRange == .init(location: 2, length: 0))

            await typer.handle(event: .skkUp)
            #expect(typer.markedTextRange == .init(location: 1, length: 0))

            // does nothing
            await typer.handle(event: .skkLeft)
            #expect(typer.markedTextRange == .init(location: 1, length: 0))

            await typer.handle(event: .skkRight)
            #expect(typer.markedTextRange == .init(location: 2, length: 0))

            await typer.handle(event: .skkDown)
            #expect(typer.markedTextRange == .init(location: 3, length: 0))

            await typer.handle(event: .skkJmode)
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "きょ")
        }
    }

    @Test func implicitTransition() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "A")
            await typer.handle(event: .skkBackspace)
            await typer.handle(event: .skkBackspace)
            await typer.type(text: "a")
            #expect(typer.insertedText == "あ")
        }
    }

    @Test func implicitConfirm() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")

            await typer.type(text: "ha")
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "今日は")
        }
    }
}
