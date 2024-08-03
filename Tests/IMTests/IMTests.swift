//
//  AquaSKKServerTests.swift
//  AquaSKKServerTests
//
//  Created by mzp on 7/31/24.
//

@testable import AquaSKKIM
import Testing

struct AquaSKKServerTests {
    @Test func example() async throws {
        let typer = await Typer()
        await typer.type(text: "aiueo")
        #expect(await typer.text == "あいうえお")
        #expect(await typer.markedText == "")
        await typer.close()
    }
}
