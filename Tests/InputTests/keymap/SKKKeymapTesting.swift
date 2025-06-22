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
        #expect(keymap.fetch(charCode: 0, keyCode: 0, modifiers: 0) == .init(id: .charInput, code: 0))
        #expect(keymap.fetch(charCode: 0x03, keyCode: 0, modifiers: 0) == .init(id: .enter, code: 0x03))
        #expect(keymap.fetch(charCode: 0x09, keyCode: 0, modifiers: 0) == .init(id: .tab, code: 0x09))
        #expect(keymap.fetch(charCode: 0x1C, keyCode: 0, modifiers: 0) == .init(id: .left, code: 0x1C))
    }

    @Test func attribute() {
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0).attribute == [.inputChars])
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0).attribute == [.toggleKana, .inputChars])
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: kCtrl).attribute == [.toggleJisx0201Kana])

        #expect(keymap.fetch(charCode: charCode("A"), keyCode: 0, modifiers: 0).attribute == [.upperCases, .inputChars])
        #expect(keymap.fetch(charCode: charCode("1"), keyCode: 0x51, modifiers: 0).attribute == [.direct])
    }

    @Test func modifiers() {
        #expect(keymap.fetch(charCode: charCode("j"), keyCode: 0, modifiers: kCtrl) == .init(id: .jmode, code: charCode("j")))
        #expect(keymap.fetch(charCode: charCode("i"), keyCode: 0, modifiers: kCtrl) == .init(id: .tab, code: charCode("i")))
        #expect(keymap.fetch(charCode: charCode("g"), keyCode: 0, modifiers: kCtrl) == .init(id: .cancel, code: charCode("g")))

        #expect(keymap.fetch(charCode: charCode("f"), keyCode: 0, modifiers: kCtrl) == .init(id: .right, code: charCode("f")))

        #expect(keymap.fetch(charCode: 0x20, keyCode: 0, modifiers: kShift) == .init(id: .charInput, code: 0x20, attribute: [.prevCandidate, .compConversion]))

        #expect(keymap.fetch(charCode: charCode("v"), keyCode: 0, modifiers: kMeta) == .init(id: .paste, code: charCode("v")))
    }

    @Test func patch() throws {
        let bundle = Bundle(for: InputTestBundle.self)
        let resource = TestingResource(bundle: bundle)
        let path = try resource.path("keymap_patch.conf")
        keymap.patch(path: path)

        // not changed
        #expect(keymap.fetch(charCode: charCode("b"), keyCode: 0, modifiers: 0) == .init(id: .charInput, code: charCode("b"), attribute: [.inputChars]))

        // remove attributes
        #expect(keymap.fetch(charCode: charCode("q"), keyCode: 0, modifiers: 0) == .init(id: .charInput, code: charCode("q"), attribute: [.inputChars]))
        #expect(keymap.fetch(charCode: charCode("\""), keyCode: 0, modifiers: 0) == .init(id: .charInput, code: charCode("\""), attribute: [.upperCases, .inputChars]))
    }
}
