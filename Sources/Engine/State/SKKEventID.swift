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
