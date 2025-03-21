//
//  ConfigTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct ConfigTests {
    // MARK: - Enablement

    @Test func annotation() async {
        let session = Typer.Session()
        await session.run(config: .defaults(annotation: false)) { typer in
            await typer.type(text: "Kyou ")
            let annotation = typer.annotation
            #expect(annotation.visible == false)
        }
    }

    @Test func dynamicCompletion() async {
        let session = Typer.Session()
        await session.run(config: .defaults(dynamicCompletion: false)) { typer in
            await typer.type(text: "K")
            await typer.type(text: "y")
            await typer.type(text: "o")

            let completion = typer.completion
            #expect(completion.prefixSize == 0)
        }
    }

    // MARK: - Behavior

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
            let handled = await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "きょう")
            #expect(handled == false)
        }

        await session.run(config: .defaults(suppressNewlineOnCommit: true)) { typer in
            await typer.type(text: "Kyou ")
            let markedText = typer.markedText
            let handled = await typer.handle(event: .skkEnter)
            #expect(markedText.hasSuffix(typer.insertedText))
            #expect(handled == true)
        }

        await session.run(config: .defaults(suppressNewlineOnCommit: false)) { typer in
            await typer.type(text: "Kyou ")
            let markedText = typer.markedText
            let handled = await typer.handle(event: .skkEnter)
            #expect(markedText.hasSuffix(typer.insertedText))
            #expect(handled == false)
        }
    }

    @Test func inlineBackSpaceImpliesCommit() async {
        let session = Typer.Session()
        await session.run(config: .defaults(inlineBackSpaceImpliesCommit: true)) { typer in
            await typer.type(text: "Kyou ")
            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "今日")
        }
    }

    @Test func handleRecursiveEntryAsOkuri() async {
        let session = Typer.Session()
        await session.run(config: .defaults(handleRecursiveEntryAsOkuri: true)) { typer in
            await typer.type(text: "A")
            #expect(typer.markedText == "▽あ")
            await typer.type(text: "Q")
            #expect(typer.markedText == "▽あ*")
            await typer.type(text: "ri")
            #expect(typer.markedText == "▼有り")
        }
    }
}
