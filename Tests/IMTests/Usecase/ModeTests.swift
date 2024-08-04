//
//  ModeTests.swift
//  CoreTests
//
//  Created by mzp on 8/3/24.
//

import Testing
import AppKit

struct ModeTest {
    @Test func switchByKeyCommand() async {
        let typer = await Typer()
        await typer.type(character: "l", keycode: 35)
        let modeIdentifier = await typer.modeIdentifier
        #expect(modeIdentifier == "com.apple.inputmethod.Roman")
        await typer.deactivate()
    }
}
