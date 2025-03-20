//
//  TransliterateTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import Testing

struct TransliterateTests {
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
}
