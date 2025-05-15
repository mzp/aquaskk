//
//  SKKKeyStateTest.swift
//  BackendTests
//
//  Created by mzp on 2025/05/12.
//

import Testing
@testable internal import AquaSKKInput

struct SKKKeyStateTest {
    @Test func keycode() {
        let keyState = SKKKeyState.KeyCode(0x31, .shift)
        #expect(keyState.charCode == 0)
        #expect(keyState.keyCode == 0x31)
        #expect(keyState.mods == SKKKeyModifier.shift)
    }

    @Test func charCode() {
        let keyState = SKKKeyState.CharCode(0x31, .shift)
        #expect(keyState.charCode == 0x31)
        #expect(keyState.keyCode == 0)
        #expect(keyState.mods == SKKKeyModifier.shift)
    }

    @Test func equals() {
        let keyState1 = SKKKeyState.KeyCode(0x31, .shift)
        let keyState2 = SKKKeyState.KeyCode(0x31, .shift)
        #expect(keyState1 == keyState2)
        #expect(keyState1.rawValue == keyState2.rawValue)
        #expect(keyState1.hashValue == keyState2.hashValue)
    }
}
