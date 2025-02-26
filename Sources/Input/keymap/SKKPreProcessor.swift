//
//  SKKPreProcessor.swift
//  AquaSKKInput
//
//  Created by mzp on 2/9/25.
//

import AquaSKKEngine
import Foundation
import OSLog

@objc(SKKPreProcessor)
public class SKKPreProcessor: NSObject {
    private var keymap: SKKKeymapImpl

    /// シングルトン
    public static let sharedInstance = SKKPreProcessor()

    @objc public static func shared() -> SKKPreProcessor {
        return sharedInstance
    }

    override public init() {
        keymap = .init()
        super.init()
    }

    /// キーマップのロード
    @objc public func initialize(path: String) {
        keymap.initialize(path: path)
    }

    /// キーマップの追加ロード
    @objc public func patch(path: String) {
        keymap.patch(path: path)
    }

    /// NSEvent → SKKEvent 変換
    @objc public func execute(event: NSEvent) -> SKKEvent {
        let modifierFlags = event.modifierFlags

        let dispstr = event.characters
        let dispchar = dispstr?.first

        let charstr = event.charactersIgnoringModifiers
        var charcode = charstr?.first
        let keycode = Int32(event.keyCode)

        var mods: Int32 = 0
        if modifierFlags.contains(.shift) {
            if dispchar?.isLetter == true {
                charcode = dispchar
            }
            mods += SKKKeyModifier.shift.rawValue
        }
        if modifierFlags.contains(.control) {
            mods += SKKKeyModifier.control.rawValue
        }
        if modifierFlags.contains(.option) {
            mods += SKKKeyModifier.option.rawValue
        }
        if modifierFlags.contains(.command) {
            mods += SKKKeyModifier.command.rawValue
        }
        // 英数キー、かなキーの文字コードがスペースのため、0 にする
        if keycode == 0x66 || keycode == 0x68 {
            charcode = nil
        }
        var result = keymap.fetch(charCode: Int(charcode?.asciiValue ?? 0), keyCode: Int(keycode), modifiers: Int(mods))

        if modifierFlags.contains(.capsLock) {
            result.option |= Int32(CapsLock)
        }

        Logger.skkInput.debug("\(#function, privacy: .public) event=\(event.description, privacy: .private)")
        Logger.skkInput.debug("\(#function, privacy: .public) result=\(result.dump(), privacy: .private)")

        return result
    }
}
