//
//  PreferenceTests.swift
//  AppTests
//
//  Created by mzp on 8/16/24.
//

import AquaSKKService
import Testing

struct PreferenceTests {
    @Test func overrideKeyboardLayout() async throws {
        let storage = PreferenceStorage.default
        let originalLayout = storage.keyboardLayout
        defer { storage.keyboardLayout = originalLayout }
        storage.keyboardLayout = "com.example.keylayout.ABC"

        let session = Typer.Session()
        await session.run { typer in
            await typer.setInputMode("com.apple.inputmethod.Roman")
            #expect(typer.keyboardLayout == "com.example.keylayout.ABC")
        }
    }
}
