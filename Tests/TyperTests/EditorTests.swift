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

    // MARK: - Composing
    @Test func composinc() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            #expect(typer.markedText == "▽きょう")
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

