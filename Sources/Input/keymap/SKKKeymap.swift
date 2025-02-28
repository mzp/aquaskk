//
//  SKKKeymap.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/02/26.
//

import AquaSKKEngine
import AquaSKKLogging
import Foundation
import OSLog

enum SKKTask {
    static func perfromAndWait<T>(timeout: DispatchTime = .distantFuture, run: @escaping () async -> T?) -> T? {
        var value: T?
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            defer { semaphore.signal() }
            value = await run()
        }
        _ = semaphore.wait(timeout: timeout)
        return value
    }
}

public class SKKKeymapImpl {
    var events: [SKKKeyState: Int] = [:]
    var attributes: [SKKKeyState: Int] = [:]
    var option: [SKKKeyState: Int] = [:]

    // MARK: - Load

    public init() {}

    /// 初期化
    public func initialize(path: String) {
        SKKTask.perfromAndWait {
            try? await self.initialize(path: path)
        }
    }

    public func initialize(path: String) async throws {
        events = [:]
        try await load(path: path)
    }

    /// 追加の読み込み
    public func patch(path: String) {
        SKKTask.perfromAndWait {
            try? await self.patch(path: path)
        }
    }

    /// 追加の読み込み
    public func patch(path: String) async throws {
        try await load(path: path)
    }

    private func load(path: String) async throws {
        for try await line in URL(fileURLWithPath: path).lines {
            // コメントは無視
            if line.hasPrefix("#") { continue }
            let fields = line.split(separator: /\s/)
            guard fields.count >= 2 else {
                Logger.skkInput.error("\(#function, privacy: .public): invalid line: \(line)")
                continue
            }
            guard let entry = SKKKeymapEntryImpl(key: String(fields[0]), value: String(fields[1])) else {
                Logger.skkInput.error("\(#function, privacy: .public): invalid line: \(line)")
                continue
            }
            for key in entry.keys {
                // 明示的なイベント
                if entry.isEvent {
                    events[key] = entry.symbol
                    continue
                }

                // SKK_CHAR 属性
                if entry.isAttribute {
                    // NotInputChars q とあった場合、qからInputChars属性をはずす
                    if entry.isNot {
                        attributes[key] = attributes[key, default: 0] & ~entry.symbol
                    } else {
                        events[key] = SKK_CHAR
                        attributes[key] = attributes[key, default: 0] | entry.symbol
                    }
                    continue
                }

                // 処理オプション
                option[key] = entry.symbol
            }
        }
    }

    // MARK: - Loookup

    /// 検索
    public func fetch(charCode: Int, keyCode: Int, modifiers: Int) -> SKKEvent {
        var event = SKKEvent()
        event.code = UInt8(charCode)
        event.id = Int32(find(charCode: charCode, keyCode: keyCode, modifiers: modifiers, from: events) ?? SKK_CHAR)

        // SKK_CHAR イベントなら属性も調べる
        if event.id == SKK_CHAR {
            if let attribute = find(charCode: charCode, keyCode: keyCode, modifiers: modifiers, from: attributes) {
                event.attribute = Int32(attribute)
            }
        }

        if let option = find(charCode: charCode, keyCode: keyCode, modifiers: modifiers, from: option) {
            event.option = Int32(option)
        }
        return event
    }

    func find(charCode: Int, keyCode: Int, modifiers: Int, from keymap: [SKKKeyState: Int]) -> Int? {
        // まずキーコードで調べる(優先度高)
        if let value = keymap[SKKKeyState.KeyCode(Int32(keyCode), Int32(modifiers))] {
            return value
        }

        // キャラクターコードを調べる
        if let value = keymap[SKKKeyState.CharCode(Int32(charCode), Int32(modifiers))] {
            return value
        }

        // 互換性保持のためシフトを押してない場合のキーマップを調べる
        if let scala = UnicodeScalar(charCode),
           Character(scala).isLetter,
           modifiers & Int(SKKKeyModifier.shift.rawValue) != 0
        {
            return find(charCode: charCode, keyCode: keyCode, modifiers: modifiers & Int(~SKKKeyModifier.shift.rawValue), from: keymap)
        }

        return nil
    }
}
