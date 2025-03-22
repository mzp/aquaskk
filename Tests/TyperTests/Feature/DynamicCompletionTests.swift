//
//  DynamicCompletionTests.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/21.
//
import Testing

struct DynamicCompletionTests {
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

    @Test func enablement() async {
        let session = Typer.Session()
        await session.run(config: .defaults(dynamicCompletion: false)) { typer in
            await typer.type(text: "K")
            await typer.type(text: "y")
            await typer.type(text: "o")

            let completion = typer.completion
            #expect(completion.prefixSize == 0)
        }
    }
}
