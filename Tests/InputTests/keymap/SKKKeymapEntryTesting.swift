//
//  SKKKeymapEntryTesting.swift
//  BackendTests
//
//  Created by mzp on 2025/02/25.
//

import Testing
@testable internal import AquaSKKInput

struct SKKKeymapEntryTesting {
    @Test func incorrect() {
        #expect(SKKKeymapEntryImpl(key: "Unknown", value: "a") == nil)
    }

    @Test func charCode() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "SKK_JMODE", value: "a"))
        let aKey = SKKKeyState.CharCode(Int32(Character("a").asciiValue!), 0)
        #expect(entry.keys == [aKey])
        #expect(entry.symbol == SKK_JMODE)
    }

    @Test func keyCode() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "SKK_JMODE", value: "keycode::0x0a"))
        let aKey = SKKKeyState.KeyCode(0x0A, 0)
        #expect(entry.keys == [aKey])
        #expect(entry.symbol == SKK_JMODE)
    }

    @Test func hexCode() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "SKK_ENTER", value: "hex::0x03"))
        let aKey = SKKKeyState.CharCode(0x03, 0)
        #expect(entry.keys == [aKey])
    }

    @Test func modifier() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "SKK_ENTER", value: "ctrl::m"))
        let aKey = SKKKeyState.CharCode(Int32(Character("m").asciiValue!), 1 << 2)
        #expect(entry.keys == [aKey])
    }

    @Test func group() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "Direct", value: "group::a,c,d-f"))
        #expect(!entry.isNot)
        #expect(!entry.isEvent)
        #expect(entry.symbol == Direct)

        let aKey = SKKKeyState.CharCode(Int32(Character("a").asciiValue!), 0)
        let cKey = SKKKeyState.CharCode(Int32(Character("c").asciiValue!), 0)
        let dKey = SKKKeyState.CharCode(Int32(Character("d").asciiValue!), 0)
        let eKey = SKKKeyState.CharCode(Int32(Character("e").asciiValue!), 0)
        let fKey = SKKKeyState.CharCode(Int32(Character("f").asciiValue!), 0)
        #expect(entry.keys == [
            aKey,
            cKey,
            dKey,
            eKey,
            fKey,
        ])
    }

    @Test func notWithGroup() throws {
        let entry = try #require(SKKKeymapEntryImpl(key: "NotDirect", value: "group::a,c,d-f"))
        #expect(entry.isNot)
        #expect(!entry.isEvent)
        #expect(entry.symbol == Direct)

        let aKey = SKKKeyState.CharCode(Int32(Character("a").asciiValue!), 0)
        let cKey = SKKKeyState.CharCode(Int32(Character("c").asciiValue!), 0)
        let dKey = SKKKeyState.CharCode(Int32(Character("d").asciiValue!), 0)
        let eKey = SKKKeyState.CharCode(Int32(Character("e").asciiValue!), 0)
        let fKey = SKKKeyState.CharCode(Int32(Character("f").asciiValue!), 0)
        #expect(entry.keys == [
            aKey,
            cKey,
            dKey,
            eKey,
            fKey,
        ])
    }
}
