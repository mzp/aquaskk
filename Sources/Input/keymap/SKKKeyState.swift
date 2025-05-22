//
//  SKKKeyState.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/25.
//

/// 以下のようなキー状態を作り出すユーティリティクラス
///
///  31       23       15       7      0 bit
/// +--------+--------+--------+--------+
/// + 未使用 |modifier|key code| ascii  |
/// +--------+--------+--------+--------+
///
/// modifier は shift, ctrl, alt(=opt), meta(=cmd)
///
public struct SKKKeyState: Equatable, Hashable {
    public var charCode: Int
    public var keyCode: Int
    public var mods: SKKKeyModifier

    public init(charCode: Int, keyCode: Int, mods: SKKKeyModifier) {
        self.charCode = charCode
        self.keyCode = keyCode
        self.mods = mods
    }

    public init(rawValue: Int) {
        mods = SKKKeyModifier(rawValue: (rawValue >> 16) & 0xFFFF)
        keyCode = (rawValue >> 8) & 0xFF
        charCode = rawValue & 0xFF
    }

    public static func KeyCode(_ keyCode: Int32, _ mods: SKKKeyModifier) -> SKKKeyState {
        return Self(charCode: 0, keyCode: Int(keyCode), mods: mods)
    }

    public static func CharCode(_ charCode: Int32, _ mods: SKKKeyModifier) -> SKKKeyState {
        Self(charCode: Int(charCode), keyCode: 0, mods: mods)
    }

    public var rawValue: Int {
        (mods.rawValue << 16) | ((0xFF & keyCode) << 8) | (0xFF & charCode)
    }
}
