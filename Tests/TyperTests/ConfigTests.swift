//
//  ConfigTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct ConfigTests {
    @Test func annotation() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.entry == "今日")
            #expect(annotation.visible == true)
        }

        await session.run(config: .defaults(annotation: false)) { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.visible == false)
        }
    }

    @Test func suppressNewlineOnCommit() async {
        let session = Typer.Session()
        await session.run(config: .defaults(suppressNewlineOnCommit: true)) { typer in
            await typer.type(text: "Kyou")
            let handled = await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "きょう")
            #expect(handled == true)
        }

        await session.run(config: .defaults(suppressNewlineOnCommit: false)) { typer in
            await typer.type(text: "Kyou")
           let handled =  await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "きょう")
            #expect(handled == false)
        }

        await session.run(config: .defaults(suppressNewlineOnCommit: true)) { typer in
            await typer.type(text: "Kyou ")
            let handled = await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "今日")
            #expect(handled == true)
        }

        await session.run(config: .defaults(suppressNewlineOnCommit: false)) { typer in
            await typer.type(text: "Kyou ")
           let handled =  await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "今日")
            #expect(handled == false)
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

            await typer.handle(event: .skkTab)
            #expect(typer.markedText == "▽きょう")
            #expect(typer.insertedText == "")
        }
    }
}
