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
    var keymap : SKKKeymapImpl
    let kCtrl = Int(SKKKeyModifier.control.rawValue)
    let kShift = Int(SKKKeyModifier.shift.rawValue)
    let kMeta = Int(SKKKeyModifier.command.rawValue)

    init() throws {
        let bundle = Bundle(for: InputTestBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("keymap.conf")
        self.keymap = SKKKeymapImpl()
        keymap.initialize(path: path)
    }

    func charCode(_ c : Character) -> Int { Int(c.asciiValue ?? 0) }

    @Test func main() {
        #expect(keymap.fetch(charCode: 0, keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_CHAR), 0, 0))
        #expect(keymap.fetch(charCode: 0x03, keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_ENTER), 0x03, 0))
        #expect(keymap.fetch(charCode: 0x09, keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_TAB), 0x09, 0))
    }

    @Test func option() throws {
        #expect(keymap.fetch(charCode: 0x1c, keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_LEFT), 0x1c, 0))
    }

    @Test func attribute() {
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0).attribute == Int32(InputChars))
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0).attribute == Int32(ToggleKana | InputChars))
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: kCtrl).attribute == Int32(ToggleJisx0201Kana))

        #expect(keymap.fetch(charCode: charCode("A"), keyCode: 0, modifiers: 0).attribute == Int32(UpperCases | InputChars))
        #expect(keymap.fetch(charCode: charCode("1"), keyCode: 0x51, modifiers: 0).attribute == Int32(Direct))
    }

    @Test func modifiers() {
        #expect(keymap.fetch(charCode: charCode("j"), keyCode: 0, modifiers: kCtrl) == SKKEvent(Int32(SKK_JMODE), UInt8(charCode("j")), 0))
        #expect(keymap.fetch(charCode: charCode("i"), keyCode: 0, modifiers: kCtrl) == SKKEvent(Int32(SKK_TAB), UInt8(charCode("i")), 0))
        #expect(keymap.fetch(charCode: charCode("g"), keyCode: 0, modifiers: kCtrl) == SKKEvent(Int32(SKK_CANCEL), UInt8(charCode("g")), 0))

        #expect(keymap.fetch(charCode: charCode("f"), keyCode: 0, modifiers: kCtrl) == SKKEvent(Int32(SKK_RIGHT), UInt8(charCode("f")), 0))

        #expect(keymap.fetch(charCode: 0x20, keyCode: 0, modifiers: kShift) == SKKEvent(Int32(SKK_CHAR), 0x20, Int32(PrevCandidate | CompConversion)))

        #expect(keymap.fetch(charCode: charCode("v"), keyCode: 0, modifiers: kMeta) == SKKEvent(Int32(SKK_PASTE), UInt8(charCode("v")), 0))
    }

    @Test func patch() throws {
        let bundle = Bundle(for: InputTestBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("keymap_patch.conf")
        keymap.patch(path: path)

        // not changed
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_CHAR), UInt8(charCode("b")), Int32(InputChars)))

        // remove attributes
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_CHAR), UInt8(charCode("q")), Int32(InputChars)))
        #expect(keymap.fetch(charCode: charCode("\""), keyCode: 0, modifiers: 0) == SKKEvent(Int32(SKK_CHAR), UInt8(charCode("\"")), Int32(UpperCases | InputChars)))
    }

}
