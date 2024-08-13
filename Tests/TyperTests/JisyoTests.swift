//
//  JisyoTests.swift
//  AppTests
//
//  Created by mzp on 8/13/24.
//

import Testing

struct JisyoTests {
    @Test func convert() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            #expect(typer.markedText == "▽きょう")
            #expect(typer.insertedText == "")

            await typer.type(text: " ")

            #expect(typer.markedText == "▼今日")
            #expect(typer.insertedText == "")

            await typer.type(text: "\n")
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "今日")
        }
    }
}
