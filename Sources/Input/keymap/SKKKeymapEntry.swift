//
//  SKKKeymapEntry.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/25.
//

import AquaSKKEngine
import AquaSKKLogging
import OSLog

/// エントリーのタイプ
enum KeymapEntryType {
    case event // SKK_* イベント
    case attribute // SKK_CHAR の属性
    case handleOption // 処理オプション
}

struct SKKKeymapEntryImpl {
    var key: String
    var symbol: Int
    var type: KeymapEntryType
    var not: Bool
    var keys: [SKKKeyState]

    init?(key: String, value: String) {
        if key.hasPrefix("Not") {
            self.key = String(key.dropFirst(3 /* Not */ ))
            not = true
        } else {
            self.key = key
            not = false
        }
        guard let entry = Self.keymapTable[self.key] else {
            Logger.skkInput.error("\(#function, privacy: .public): invalid key name[\(key, privacy: .public)]")
            return nil
        }
        symbol = entry.symbol
        type = entry.type

        keys = []
        for label in value.split(separator: "||") {
            let parser = SKKKeymapParser(string: String(label))
            keys.append(contentsOf: parser.parse())
        }
    }

    // MARK: - Properties

    var isEvent: Bool { type == .event }
    var isAttribute: Bool { type == .attribute }
    var isNot: Bool { not }

    // MARK: - Keymap entry definition

    struct KeymapEntry {
        var symbol: Int
        var type: KeymapEntryType
    }

    static let keymapTable: [String: KeymapEntry] = [
        "SKK_JMODE": .init(symbol: Int(SKKEventID.jmode.rawValue), type: .event),
        "SKK_ENTER": .init(symbol: Int(SKKEventID.enter.rawValue), type: .event),
        "SKK_CANCEL": .init(symbol: Int(SKKEventID.cancel.rawValue), type: .event),
        "SKK_BACKSPACE": .init(symbol: Int(SKKEventID.backspace.rawValue), type: .event),
        "SKK_DELETE": .init(symbol: Int(SKKEventID.delete_.rawValue), type: .event),
        "SKK_TAB": .init(symbol: Int(SKKEventID.tab.rawValue), type: .event),
        "SKK_PASTE": .init(symbol: Int(SKKEventID.paste.rawValue), type: .event),
        "SKK_LEFT": .init(symbol: Int(SKKEventID.left.rawValue), type: .event),
        "SKK_RIGHT": .init(symbol: Int(SKKEventID.right.rawValue), type: .event),
        "SKK_UP": .init(symbol: Int(SKKEventID.up.rawValue), type: .event),
        "SKK_DOWN": .init(symbol: Int(SKKEventID.down.rawValue), type: .event),
        "SKK_CHAR": .init(symbol: Int(SKKEventID.charInput.rawValue), type: .event),
        "SKK_PING": .init(symbol: Int(SKKEventID.ping.rawValue), type: .event),
        "SKK_YES": .init(symbol: Int(SKKEventID.yes.rawValue), type: .event),
        "SKK_NO": .init(symbol: Int(SKKEventID.no.rawValue), type: .event),
        "SKK_UNDO": .init(symbol: Int(SKKEventID.undo.rawValue), type: .event),

        "Direct": .init(symbol: SKKAttribute.direct.rawValue, type: .attribute),
        "UpperCases": .init(symbol: SKKAttribute.upperCases.rawValue, type: .attribute),
        "ToggleKana": .init(symbol: SKKAttribute.toggleKana.rawValue, type: .attribute),
        "ToggleJisx0201Kana": .init(symbol: SKKAttribute.toggleJisx0201Kana.rawValue, type: .attribute),
        "SwitchToAscii": .init(symbol: SKKAttribute.switchToAscii.rawValue, type: .attribute),
        "SwitchToJisx0208Latin": .init(symbol: SKKAttribute.switchToJisx0208Latin.rawValue, type: .attribute),
        "EnterJapanese": .init(symbol: SKKAttribute.enterJapanese.rawValue, type: .attribute),
        "EnterAbbrev": .init(symbol: SKKAttribute.enterAbbrev.rawValue, type: .attribute),
        "NextCompletion": .init(symbol: SKKAttribute.nextCompletion.rawValue, type: .attribute),
        "PrevCompletion": .init(symbol: SKKAttribute.prevCompletion.rawValue, type: .attribute),
        "NextCandidate": .init(symbol: SKKAttribute.nextCandidate.rawValue, type: .attribute),
        "PrevCandidate": .init(symbol: SKKAttribute.prevCandidate.rawValue, type: .attribute),
        "RemoveTrigger": .init(symbol: SKKAttribute.removeTrigger.rawValue, type: .attribute),
        "InputChars": .init(symbol: SKKAttribute.inputChars.rawValue, type: .attribute),
        "CompConversion": .init(symbol: SKKAttribute.compConversion.rawValue, type: .attribute),
        "StickyKey": .init(symbol: SKKAttribute.stickyKey.rawValue, type: .attribute),

        "AlwaysHandled": .init(symbol: SKKHandleOption.alwaysHandled.rawValue, type: .handleOption),
        "PseudoHandled": .init(symbol: SKKHandleOption.pseudoHandled.rawValue, type: .handleOption),
    ]
}
