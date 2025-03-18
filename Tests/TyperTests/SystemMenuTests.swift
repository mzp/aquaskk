//
//  SystemMenuTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/17.
//

internal import AquaSKKBackend
import Testing

struct SystemEvevtTests {
    @Test("event", arguments: [
        ("com.apple.inputmethod.Japanese.Hiragana", SKKInputMode.HirakanaInputMode, "あいうえお"),
        ("com.apple.inputmethod.Japanese.Katakana", SKKInputMode.KatakanaInputMode, "アイウエオ"),
        ("com.apple.inputmethod.Japanese.HalfWidthKana", SKKInputMode.Jisx0201KanaInputMode, "ｱｲｳｴｵ"),
        ("com.apple.inputmethod.Japanese.FullWidthRoman", SKKInputMode.Jisx0208LatinInputMode, "ａｉｕｅｏ"),
    ]) func transitionInputMode(modeIdentifier: String, inputMode: SKKInputMode, expected: String) async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Roman")

            await typer.setValue(modeIdentifier)

            // 2nd call does nothing
            await typer.setValue(modeIdentifier)
            #expect(typer.inputMode == inputMode)
            await typer.type(text: "aiueo")
            #expect(typer.insertedText == expected)
        }
    }

    func asciiInputMode() async {
        let session = Typer.Session()
        await session.run { typer in
            await typer.setValue("com.apple.inputmethod.Roman")
            await typer.setValue("com.apple.inputmethod.Roman")
            let handled = await typer.handle(event: .init(characters: "a"))
            #expect(handled == false)
        }
    }
}
