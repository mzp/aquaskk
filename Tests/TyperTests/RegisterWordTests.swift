//
//  RegisterWordTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct RegisterWordTests {
    @Test func register() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Maji ")
            #expect(typer.markedText == "[登録：まじ]")
        }
    }

    @Test func yank() async {
        let session = Typer.Session()
        await session.run { typer in
            typer.set(pasteString: "HELLO")
            await typer.type(text: "/hello ")
            await typer.type(text: "y", modifiers: [.control])
            #expect(typer.markedText == "[登録：hello]HELLO")
            #expect(typer.markedTextRange == .init(location: 15, length: 0))

            await typer.handle(event: .skkLeft)
            #expect(typer.markedTextRange == .init(location: 14, length: 0))
            await typer.handle(event: .skkRight)
            #expect(typer.markedTextRange == .init(location: 15, length: 0))
            await typer.handle(event: .skkUp)
            #expect(typer.markedTextRange == .init(location: 10, length: 0))
            await typer.handle(event: .skkDown)
            #expect(typer.markedTextRange == .init(location: 15, length: 0))

            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText == "[登録：hello]HELL")
            #expect(typer.markedTextRange == .init(location: 14, length: 0))

            await typer.handle(event: .skkLeft)
            await typer.handle(event: .skkDelete)
            #expect(typer.markedText == "[登録：hello]HEL")
            #expect(typer.markedTextRange == .init(location: 13, length: 0))
            await typer.handle(event: .skkJmode)
        }
    }

    @Test func remove() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Tango ")
            #expect(typer.markedText == "▼単語")
            await typer.type(text: "X", modifiers: [.shift])
            #expect(typer.markedText == "たんご /単語/ を削除しますか？(yes/no) ")
            await typer.type(text: "yes")
            #expect(typer.markedText == "たんご /単語/ を削除しますか？(yes/no) yes")
            await typer.handle(event: .skkEnter)
            typer.clear()
            await typer.type(text: "Tango ")
            // FIXME: #expect(typer.markedText == "▼単語")
        }
    }
}
