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
        let typer = await Typer()
        typer.type(character: "l", keycode: 35)
        let modeIdentifier = typer.modeIdentifier
        #expect(modeIdentifier == "com.apple.inputmethod.Roman")
    }
}
