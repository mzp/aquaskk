//
//  ModeTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import AppKit
import Testing

struct ModeTest {
    @Test func switchByKeyCommand() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.type(character: "l", keycode: 35)
            #expect(typer.modeIdentifier == "com.apple.inputmethod.Roman")
        }
    }
}
