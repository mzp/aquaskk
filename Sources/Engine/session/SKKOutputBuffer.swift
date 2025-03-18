//
//  SKKOutputBuffer.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

import AquaSKKLogging
import OSLog

public class SKKOutputBufferImpl {
    private let frontend: SKKFrontEnd
    private var composing: String
    private var cursor: String.Index
    private var mark: String.Index

    private var start: Int
    private var length: Int

    private var currentDisplayString: String
    public init(frontend: SKKFrontEnd) {
        self.frontend = frontend
        composing = ""
        cursor = composing.startIndex
        mark = composing.startIndex
        start = 0
        length = 0
        currentDisplayString = ""
    }

    public func fix(string: String) {
        frontend.InsertString(std.string(string))
    }

    public func compose(string: String, cursor offset: Int = 0) {
        composing.insert(contentsOf: string, at: cursor)
        cursor = composing.index(composing.startIndex, offsetBy: composing.count + offset)
        if !composing.isEmpty {
            Logger.skkEngine.info("""
            [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
            "\(self.composing, privacy: .private)"\
            (length=\(self.composing.count, privacy: .public)) \
            cursor=\(self.cursor.debugDescription, privacy: .public) \
            offset=\(offset, privacy: .public)
            """)
        }
    }

    public func convert(string: String) {
        start = composing[composing.startIndex ..< cursor].count
        length = string.count
        compose(string: string, cursor: 0)
    }

    public func setMark() {
        mark = cursor
    }

    public func getMark() -> Int {
        mark.utf16Offset(in: composing)
    }

    public func clear() {
        composing = ""
        cursor = composing.startIndex
        mark = composing.startIndex
        start = 0
        length = 0
    }

    public func output() {
        if composing == currentDisplayString, composing.isEmpty {
            return
        }
        let offset = -composing.distance(from: cursor, to: composing.endIndex)
        if length > 0 {
            frontend.ComposeString(std.string(composing), Int32(start), Int32(length))
        } else {
            frontend.ComposeString(std.string(composing), Int32(offset))
        }
        currentDisplayString = composing
    }

    public var isComposing: Bool {
        !composing.isEmpty
    }
}
