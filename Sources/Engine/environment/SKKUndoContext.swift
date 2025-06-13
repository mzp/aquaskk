//
//  SKKUndoContext.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

import AquaSKKLogging
import OSLog

@objc public class SKKUndoContextImpl: NSObject {
    private let frontend: SKKFrontEndProtocol
    @objc public private(set) var entry: String
    @objc public private(set) var candidate: String
    @objc public init(frontend: SKKFrontEndProtocol) {
        self.frontend = frontend
        entry = ""
        candidate = ""
    }

    @objc public func undo() -> SKKUndoResult {
        candidate = frontend.selectedString()

        // 逆引き
        entry = SKKBackendImpl.shared().reverseLookup(candidate: candidate)

        if entry.isEmpty {
            return .UndoFailed
        }

        // 表示不可能な文字が含まれるか？
        // if(std::find_if(entry_.begin(), entry_.end(), std::not_fn(std::function<int(int)>(isprint))) != entry_.end()) {
        // return SKKUndoResult::UndoKanaEntry;
        // }
        //
        // 表示不可能が何を指すかよくわからないが、実装から判断するに半角英数字かのチェックをしている
        if entry.unicodeScalars.contains(where: { !$0.isASCII }) {
            return .UndoKanaEntry
        }
        return .UndoAsciiEntry
    }

    @objc public func bridgedUndo() -> Int32 {
        Int32(undo().rawValue)
    }

    @objc public var isActive: Bool {
        !entry.isEmpty
    }

    @objc public func clear() {
        entry = ""
        candidate = ""
    }

    public func bridgeEntry() -> std.string {
        Logger.skkEngine.info("bridgeEntry: \(self.entry, privacy: .public)")
        return std.string(entry)
    }

    public func bridgeCandidate() -> std.string {
        return std.string(candidate)
    }
}
