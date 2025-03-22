//
//  UserDictionaryTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct UserDictionaryTests {
    @Test func register() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Maji ")
            #expect(typer.markedText == "[登録：まじ]")
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
