//
//  CandidateSelectorTests.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/19.
//

import Testing

struct CandidateSelectorTests {
    @Test func inline() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText == "▼今日")

            await typer.type(text: " ")
            #expect(typer.markedText == "▼京")

            await typer.type(text: "x")
            #expect(typer.markedText == "▼今日")

            await typer.type(text: "x")
            #expect(typer.markedText == "▽きょう")

            await typer.type(text: "  ")
            #expect(typer.markedText == "▼京")
            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText == "▼今日")
            await typer.handle(event: .skkRight)
            #expect(typer.markedText == "▼今日")
            await typer.handle(event: .skkJmode)
            #expect(typer.markedText == "")
            #expect(typer.insertedText == "今日")
        }
    }

    @Test func inlineCancel() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou ")
            #expect(typer.markedText.hasPrefix("▼"))
            await typer.handle(event: .skkBackspace)
            #expect(typer.markedText.hasPrefix("▽"))
        }
    }

    @Test func window() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou")
            await typer.type(text: "      ")
            #expect(typer.candidates == ["鏡", "胸", "共", "香", "狂", "経", "叫", "教", "驚", "饗", "響", "郷", "興", "脅", "矯", "況", "挟", "恭", "恐", "怯", "彊", "峡", "境", "喬", "卿", "匡", "協", "凶", "競", "兇", "僑", "侠", "供", "享", "亨", "兄"])
            #expect(typer.candidateCursor == 0)
            await typer.handle(event: .skkRight)
            #expect(typer.candidateCursor == 1)

            await typer.handle(event: .skkUp)
            #expect(typer.candidateCursor == 0)

            await typer.handle(event: .skkDown)
            #expect(typer.candidateCursor == 35)

            await typer.handle(event: .skkLeft)
            #expect(typer.candidateCursor == 34)

            await typer.handle(event: .skkEnter)
            #expect(typer.insertedText == "亨")
        }
    }

    @Test func selectByLabel() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "Kyou      ")
            await typer.type(text: "a")
            #expect(typer.insertedText == typer.candidates[0])
        }
        await session.run { typer in
            await typer.type(text: "Kyou      ")
            await typer.type(text: "b")
            #expect(typer.insertedText == typer.candidates[1])
        }
    }
}
