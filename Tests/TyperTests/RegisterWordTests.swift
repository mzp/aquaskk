//
//  RegisterWordTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct RegisterWordTests {
    @Test func yank() async {
        let session = Typer.Session()
        await session.run { typer in
            typer.set(pasteString: "HELLO")
            await typer.type(text: "/hello ")
            await typer.type(text: "y", modifiers: [.control])
            #expect(typer.markedText == "[登録：hello]HELLO")
        }
    }

    @Test func remove() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")
            await typer.type(text: "X", modifiers: [.shift])
            #expect(typer.markedText == "きょう /今日/ を削除しますか？(yes/no) ")
            await typer.type(text: "yes")
            #expect(typer.markedText == "きょう /今日/ を削除しますか？(yes/no) yes")
            await typer.handle(event: .skkEnter)
            typer.clear()
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")
        }
    }
}
