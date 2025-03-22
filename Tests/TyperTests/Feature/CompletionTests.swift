//
//  CompletionTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct CompletionTests {
    @Test func completion() async throws {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyo")
            await typer.handle(event: .skkTab)
            #expect(typer.markedText == "▽きょう")
            await typer.handle(event: .skkTab)
            #expect(typer.markedText == "▽きょういく")
            await typer.type(text: ",")
            #expect(typer.markedText == "▽きょう")
            await typer.type(text: ".")
            #expect(typer.markedText == "▽きょういく")
            await typer.type(text: " ")
            #expect(typer.markedText == "▼教育")
        }

        await session.run { typer in
            await typer.type(text: "Tangohokann")
            #expect(typer.markedText == "▽たんごほかん")
            await typer.handle(event: .skkTab)
            #expect(typer.markedText == "▽たんごほかん")
        }
    }

    @Test func removeCompletion() async throws {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Joga")
            await typer.handle(event: .skkTab)
            #expect(typer.markedText == "▽じょがい")
            await typer.type(text: "X")

            await typer.type(text: "Joga")
            await typer.handle(event: .skkTab)
            // FIXME: #expect(typer.markedText != "▽じょがい")
        }
    }
}
