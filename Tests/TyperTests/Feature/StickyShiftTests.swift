//
//  StickyShiftTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/21.
//

import Testing

struct StickyShiftTests {
    @Test func stickyShift() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: ";")
            #expect(typer.insertedText == "")
            #expect(typer.markedText == "▽")
            await typer.type(text: "a")
            #expect(typer.markedText == "▽あ")
            await typer.type(text: ";")
            #expect(typer.markedText == "▽あ*")
            await typer.type(text: "ri")
            #expect(typer.markedText == "▼有り")
        }
    }

    @Test func cancelByStickeyKey() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: ";")
            #expect(typer.insertedText == "")
            #expect(typer.markedText == "▽")
            await typer.type(text: ";")
            #expect(typer.insertedText == "；")
        }
    }

    @Test("cancel by key", arguments: [
        TyperEvent(characters: " "), // NextCandidate
        TyperEvent(characters: " ", modifiers: .shift), // CompConversion
    ]) func cancelByNextCandidate(event: TyperEvent) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: ";")
            #expect(typer.markedText == "▽")
            await typer.handle(event: event)
            #expect(typer.insertedText == "")
            #expect(typer.markedText == "")
        }
    }
}
