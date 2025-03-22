//
//  CustomBehaviorTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct CustomBehaviorTests {
    @Test func suppressNewlineOnCommit() async {
        let session = Typer.Session()
        await session.run(config: .defaults(suppressNewlineOnCommit: false)) { typer in
            await typer.type(text: "Kyou")
            let handled = await typer.handle(event: .skkEnter)
            #expect(typer.insertedText != "")
            #expect(handled == false)
        }
        await session.run(config: .defaults(suppressNewlineOnCommit: false)) { typer in
            await typer.type(text: "Kyou ")
            let handled = await typer.handle(event: .skkEnter)
            #expect(typer.insertedText != "")
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
