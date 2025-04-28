//
//  ConversionTests.swift
//  AppTests
//
//  Created by mzp on 8/13/24.
//

import Testing

struct ConversionTests {
    @Test func convert() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            #expect(typer.markedText == "▽きょう")
            #expect(typer.insertedText == "")

            await typer.type(text: " ")
            let candidates = typer.candidates
            #expect(typer.markedText == "▼今日")
            #expect(typer.insertedText == "")
            #expect(candidates.contains("鏡") == true)
            #expect(!candidates.isEmpty)

            await typer.type(text: "\n")
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "今日")
        }
    }

    @Test func convertOkuriAri() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "KoroG")
            #expect(typer.markedText == "▽ころ*g")
            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText == "▽ころ*")
            #expect(typer.markedTextRange == .init(location: 4, length: 0))

            // ignored
            for event in [TyperEvent.skkLeft, .skkDown, .skkUp, .skkRight, .skkDelete, .skkTab] {
                await typer.handle(event: event)
                #expect(typer.markedText == "▽ころ*")
                #expect(typer.markedTextRange == .init(location: 4, length: 0))
            }
            await typer.type(text: "ga")
            #expect(typer.markedText == "▼転が")
            await typer.type(text: "ru")
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "転がる")
        }
    }

    @Test func reverseConversion() async {
        let session = Typer.Session()
        await session.run { typer in
            typer.setText(string: "今日", range: .init(location: 0, length: 2))
            await typer.handle(event: .undo)
            #expect(typer.markedText == "▽きょう")
            await typer.type(text: "to")
            #expect(typer.markedText == "▽きょうと")
        }
    }
}
