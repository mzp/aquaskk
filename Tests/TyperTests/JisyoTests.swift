//
//  JisyoTests.swift
//  AppTests
//
//  Created by mzp on 8/13/24.
//

import Testing

struct JisyoTests {
    @Test func convert() async {
        let typer = await Typer()
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
