//
//  SKKKeymapTesting.swift
//  BackendTests
//
//  Created by mzp on 2025/02/26.
//

import Testing
@testable internal import AquaSKKInput
internal import AquaSKKTesting
internal import AquaSKKEngine

class InputTestBundle: NSObject {}

struct SKKKeymapTesting {
    var keymap: SKKKeymapImpl
    let kCtrl = Int(SKKKeyModifier.control.rawValue)
    let kShift = Int(SKKKeyModifier.shift.rawValue)
    let kMeta = Int(SKKKeyModifier.command.rawValue)

    init() async throws {
        let bundle = Bundle(for: InputTestBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("keymap.conf")
        keymap = SKKKeymapImpl()
        try await keymap.initialize(path: path)
    }

    func charCode(_ c: Character) -> Int { Int(c.asciiValue ?? 0) }

    @Test func main() {
        #expect(keymap.fetch(charCode: 0, keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.charInput.rawValue, 0, 0))
        #expect(keymap.fetch(charCode: 0x03, keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.enter.rawValue, 0x03, 0))
        #expect(keymap.fetch(charCode: 0x09, keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.tab.rawValue, 0x09, 0))

        #expect(keymap.fetch(charCode: 0x1C, keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.left.rawValue, 0x1C, 0))
    }

    @Test func attribute() {
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0).attribute == Int32(InputChars))
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0).attribute == Int32(ToggleKana | InputChars))
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: kCtrl).attribute == Int32(ToggleJisx0201Kana))

        #expect(keymap.fetch(charCode: charCode("A"), keyCode: 0, modifiers: 0).attribute == Int32(UpperCases | InputChars))
        #expect(keymap.fetch(charCode: charCode("1"), keyCode: 0x51, modifiers: 0).attribute == Int32(Direct))
    }

    @Test func modifiers() {
        #expect(keymap.fetch(charCode: charCode("j"), keyCode: 0, modifiers: kCtrl) == SKKEvent(SKKEventID.jmode.rawValue, UInt8(charCode("j")), 0))
        #expect(keymap.fetch(charCode: charCode("i"), keyCode: 0, modifiers: kCtrl) == SKKEvent(SKKEventID.tab.rawValue, UInt8(charCode("i")), 0))
        #expect(keymap.fetch(charCode: charCode("g"), keyCode: 0, modifiers: kCtrl) == SKKEvent(SKKEventID.cancel.rawValue, UInt8(charCode("g")), 0))

        #expect(keymap.fetch(charCode: charCode("f"), keyCode: 0, modifiers: kCtrl) == SKKEvent(SKKEventID.right.rawValue, UInt8(charCode("f")), 0))

        #expect(keymap.fetch(charCode: 0x20, keyCode: 0, modifiers: kShift) == SKKEvent(SKKEventID.charInput.rawValue, 0x20, Int32(PrevCandidate | CompConversion)))

        #expect(keymap.fetch(charCode: charCode("v"), keyCode: 0, modifiers: kMeta) == SKKEvent(SKKEventID.paste.rawValue, UInt8(charCode("v")), 0))
    }

    @Test func patch() throws {
        let bundle = Bundle(for: InputTestBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("keymap_patch.conf")
        keymap.patch(path: path)

        // not changed
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.charInput.rawValue, UInt8(charCode("b")), Int32(InputChars)))

        // remove attributes
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.charInput.rawValue, UInt8(charCode("q")), Int32(InputChars)))
        #expect(keymap.fetch(charCode: charCode("\""), keyCode: 0, modifiers: 0) == SKKEvent(SKKEventID.charInput.rawValue, UInt8(charCode("\"")), Int32(UpperCases | InputChars)))
    }
}
