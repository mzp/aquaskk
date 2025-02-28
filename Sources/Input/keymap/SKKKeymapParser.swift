//
//  SKKKeymapParser.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/25.
//

import AquaSKKLogging
import OSLog

class SKKKeymapParser {
    struct LabelType: OptionSet {
        let rawValue: Int
        static let group = LabelType(rawValue: 1 << 0)
        static let hex = LabelType(rawValue: 1 << 1)
        static let keyCode = LabelType(rawValue: 1 << 2)
    }

    var labelType: LabelType
    var modifiers: Int32
    var value: String
    init(string: String) {
        labelType = []
        modifiers = 0

        let values = string.split(separator: "::")
        value = String(values.last ?? Substring(string))
        // 各ラベルを解析する
        for label in values.dropLast() {
            switch String(label) {
            case "group":
                labelType.insert(.group)
            case "hex":
                labelType.insert(.hex)
            case "keycode":
                labelType.insert(.keyCode)
            case "shift":
                modifiers += SKKKeyModifier.shift.rawValue
            case "ctrl":
                modifiers += SKKKeyModifier.control.rawValue
            case "alt":
                modifiers += SKKKeyModifier.option.rawValue
            case "meta":
                modifiers += SKKKeyModifier.command.rawValue
            default:
                Logger.skkInput.error("\(#function, privacy: .public): invalid label prefix[\(label, privacy: .public)]")
            }
        }
    }

    func parse() -> [SKKKeyState] {
        if labelType.contains(.group) {
            parseGroup(value)
        } else {
            [parseEntry(value)]
        }
    }

    func parseGroup(_ string: any StringProtocol) -> [SKKKeyState] {
        var keys: [SKKKeyState] = []
        for field in string.split(separator: ",") {
            let entries = field.split(separator: "-")
            if entries.count < 2 {
                keys.append(parseEntry(String(field)))
            } else {
                let from = makeKey(String(entries[0])).rawValue
                let to = makeKey(String(entries[1])).rawValue

                for state in from ... to {
                    keys.append(SKKKeyState(state))
                }
            }
        }
        return keys
    }

    /// 単一エントリの解析
    func parseEntry(_ string: any StringProtocol) -> SKKKeyState {
        makeKey(String(string))
    }

    /// // キーの生成
    func makeKey(_ string: String) -> SKKKeyState {
        let key: Int32
        // 16 進数表記？
        if labelType.contains(.hex) || labelType.contains(.keyCode) {
            key = Int32(string.dropFirst(2 /* 0x */ ), radix: 16) ?? 0
        } else {
            key = Int32(string.first?.asciiValue ?? 0)
        }
        if labelType.contains(.keyCode) {
            return SKKKeyState.KeyCode(key, modifiers)
        } else {
            return SKKKeyState.CharCode(key, modifiers)
        }
    }
}
