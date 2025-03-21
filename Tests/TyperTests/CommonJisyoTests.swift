//
//  CommonJisyoTests.swift
//  AppTests
//
//  Created by mzp on 8/13/24.
//

import Testing

struct CommonJisyoTests {
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
            await typer.type(text: "a")
            #expect(typer.markedText == "▼転が")
            await typer.type(text: "ru")
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "転がる")
        }
    }

    @Test func undo() async {
        let session = Typer.Session()
        await session.run { typer in
            typer.setText(string: "今日", range: .init(location: 0, length: 2))
            await typer.handle(event: .undo)
            #expect(typer.markedText == "▽きょう")
            await typer.type(text: "to")
            #expect(typer.markedText == "▽きょうと")
        }
    }

    @Test func annotation() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.entry == "今日")
            #expect(annotation.visible == true)
        }
    }

    @Test func dynamicCompletion() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "K")
            await typer.type(text: "y")
            await typer.type(text: "o")

            let completion = typer.completion
            #expect(completion.completion == "きょう")
            #expect(completion.prefixSize == 3)
            #expect(completion.cursorOffset == 0)
            #expect(completion.visible == true)

            await typer.type(text: "u")
            #expect(typer.markedText == "▽きょう")
            #expect(typer.insertedText == "")
        }
    }
}
