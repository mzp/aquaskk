//
//  JisyoTests.swift
//  AppTests
//
//  Created by mzp on 8/13/24.
//

import Testing

@MainActor struct JisyoTests {
    @Test func convert() {
        let typer = Typer()
        typer.type(text: "Kyou")
        #expect(typer.markedText == "▽きょう")
        #expect(typer.text == "")

        typer.type(text: " ")

        #expect(typer.markedText == "▼今日")
        #expect(typer.text == "")

        typer.type(text: "\n")

        #expect(typer.markedText == "")
        #expect(typer.text == "今日")
    }
}
