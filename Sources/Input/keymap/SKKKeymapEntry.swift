//
//  SKKKeymapEntry.swift
//  AquaSKK
//
//  Created by mzp on 2025/02/25.
//

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
        "SKK_JMODE": .init(symbol: SKK_JMODE, type: .event),
        "SKK_ENTER": .init(symbol: SKK_ENTER, type: .event),
        "SKK_CANCEL": .init(symbol: SKK_CANCEL, type: .event),
        "SKK_BACKSPACE": .init(symbol: SKK_BACKSPACE, type: .event),
        "SKK_DELETE": .init(symbol: SKK_DELETE, type: .event),
        "SKK_TAB": .init(symbol: SKK_TAB, type: .event),
        "SKK_PASTE": .init(symbol: SKK_PASTE, type: .event),
        "SKK_LEFT": .init(symbol: SKK_LEFT, type: .event),
        "SKK_RIGHT": .init(symbol: SKK_RIGHT, type: .event),
        "SKK_UP": .init(symbol: SKK_UP, type: .event),
        "SKK_DOWN": .init(symbol: SKK_DOWN, type: .event),
        "SKK_CHAR": .init(symbol: SKK_CHAR, type: .event),
        "SKK_PING": .init(symbol: SKK_PING, type: .event),
        "SKK_YES": .init(symbol: SKK_YES, type: .event),
        "SKK_NO": .init(symbol: SKK_NO, type: .event),
        "SKK_UNDO": .init(symbol: SKK_UNDO, type: .event),

        "Direct": .init(symbol: Direct, type: .attribute),
        "UpperCases": .init(symbol: UpperCases, type: .attribute),
        "ToggleKana": .init(symbol: ToggleKana, type: .attribute),
        "ToggleJisx0201Kana": .init(symbol: ToggleJisx0201Kana, type: .attribute),
        "SwitchToAscii": .init(symbol: SwitchToAscii, type: .attribute),
        "SwitchToJisx0208Latin": .init(symbol: SwitchToJisx0208Latin, type: .attribute),
        "EnterJapanese": .init(symbol: EnterJapanese, type: .attribute),
        "EnterAbbrev": .init(symbol: EnterAbbrev, type: .attribute),
        "NextCompletion": .init(symbol: NextCompletion, type: .attribute),
        "PrevCompletion": .init(symbol: PrevCompletion, type: .attribute),
        "NextCandidate": .init(symbol: NextCandidate, type: .attribute),
        "PrevCandidate": .init(symbol: PrevCandidate, type: .attribute),
        "RemoveTrigger": .init(symbol: RemoveTrigger, type: .attribute),
        "InputChars": .init(symbol: InputChars, type: .attribute),
        "CompConversion": .init(symbol: CompConversion, type: .attribute),
        "StickyKey": .init(symbol: StickyKey, type: .attribute),

        "AlwaysHandled": .init(symbol: AlwaysHandled, type: .handleOption),
        "PseudoHandled": .init(symbol: PseudoHandled, type: .handleOption),
    ]
}
