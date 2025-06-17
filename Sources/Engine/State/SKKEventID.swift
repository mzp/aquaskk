//
//  SKKEventID.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/15.
//

public enum SKKEventID: Int32 {
    case exitEvent = -3
    case initEvent = -2
    case entryEvent = -1
    case probeEvent = 0
    case null = 1 // 無効なイベント
    case jmode = 2 // Ctrl-J
    case enter // Ctrl-M
    case cancel // Ctrl-G
    case backspace // Ctrl-H
    case delete_ // Ctrl-D
    case tab // Ctrl-I
    case paste // Ctrl-Y
    case left // ←
    case right // →
    case up // ↑
    case down // ↓
    case charInput // その他全てのキー入力
    case ping // CTRL-L(内部状態問い合わせ)
    case undo // CTRL-/
    case asciiMode // ASCII モード
    case hirakanaMode // ひらかなモード
    case katakanaMode // カタカナモード
    case jisx0201KanaMode // 半角カナモード
    case jisx0208LatinMode // 全角英数モード
    case yes // 仮想イベント
    case no // 仮想イベント
    case on // 仮想イベント
    case off // 仮想イベント
}

extension SKKEventID: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }

    public var debugDescription: String {
        switch self {
        case .asciiMode:
            return "asciiMode"
        case .exitEvent:
            return "exitEvent"
        case .initEvent:
            return "initEvent"
        case .entryEvent:
            return "entryEvent"
        case .probeEvent:
            return "probeEvent"
        case .null:
            return "null"
        case .jmode:
            return "jMode"
        case .enter:
            return "enter"
        case .cancel:
            return "cancel"
        case .backspace:
            return "backspace"
        case .delete_:
            return "delete"
        case .tab:
            return "tab"
        case .paste:
            return "paste"
        case .left:
            return "left"
        case .right:
            return "right"
        case .up:
            return "up"
        case .down:
            return "down"
        case .charInput:
            return "char"
        case .ping:
            return "ping"
        case .undo:
            return "undo"
        case .hirakanaMode:
            return "hirakanaMode"
        case .katakanaMode:
            return "katakanaMode"
        case .jisx0201KanaMode:
            return "jisx0201KanaMode"
        case .jisx0208LatinMode:
            return "jisx0208LatinMode"
        case .yes:
            return "yes"
        case .no:
            return "no"
        case .on:
            return "on"
        case .off:
            return "off"
        @unknown default:
            return "unknown"
        }
    }
}
