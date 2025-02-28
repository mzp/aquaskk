//
//  GadgetTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

import Foundation
import Testing

struct GadgetTests {
    @Test func math() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "/=1+2+3+4")
            await typer.type(text: " ")
            #expect(typer.markedText == "▼10")
            #expect(typer.insertedText == "")
        }
    }

    @Test func datetime() async {
        let session = Typer.Session()
        await session.run { typer in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd(EEE)"
            let expect = formatter.string(from: Date())
            await typer.type(text: "/today")
            await typer.type(text: " ")
            #expect(typer.markedText == "▼\(expect)")
            #expect(typer.insertedText == "")
        }

        await session.run { typer in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"

            await typer.type(text: "/now")
            await typer.type(text: " ")

            #expect(typer.markedText.contains(/▼..:..:../))

            #expect(typer.insertedText == "")
        }
    }

    @Test func completion() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(text: "/tod")
            await typer.type(text: "\t")
            #expect(typer.markedText == "▽today")
        }

        await session.run { typer in
            await typer.type(text: "/no")
            await typer.type(text: "\t")
            #expect(typer.markedText == "▽now")
        }
    }
}
