//
//  SKKOutputBuffer.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

import AquaSKKLogging
import OSLog

@objc public class SKKOutputBufferImpl: NSObject {
    private let frontend: SKKFrontEndProtocol
    private var composing: String
    private var cursor: String.Index
    private var mark: String.Index

    private var start: Int
    private var length: Int

    private var currentDisplayString: String
    @objc public init(frontend: SKKFrontEndProtocol) {
        self.frontend = frontend
        composing = ""
        cursor = composing.startIndex
        mark = composing.startIndex
        start = 0
        length = 0
        currentDisplayString = ""
    }

    @objc public func fix(string: String) {
        frontend.insert(string: string)
    }

    @objc public func compose(string: String, cursor offset: Int = 0) {
        composing.insert(contentsOf: string, at: cursor)
        cursor = composing.index(cursor, offsetBy: string.count + offset)
        if !composing.isEmpty {
            Logger.skkEngine.info("""
            [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
            "\(self.composing, privacy: .private)"\
            (length=\(self.composing.count, privacy: .public)) \
            cursor=\(String(describing: self.cursor), privacy: .public) \
            offset=\(offset, privacy: .public)
            """)
        }
    }

    @objc public func convert(string: String) {
        start = composing[composing.startIndex ..< cursor].count
        length = string.count
        compose(string: string, cursor: 0)
    }

    @objc public func setMark() {
        mark = cursor
    }

    @objc public func getMark() -> Int {
        mark.utf16Offset(in: composing)
    }

    @objc public func clear() {
        Logger.skkEngine.info("""
        [\(#fileID, privacy: .public):\(#function, privacy: .public)] \
        "\(self.composing, privacy: .private)"\
        (length=\(self.composing.count, privacy: .public))
        """)
        composing = ""
        cursor = composing.startIndex
        mark = composing.startIndex
        start = 0
        length = 0
    }

    @objc public func output() {
        if composing == currentDisplayString, composing.isEmpty {
            return
        }
        let offset = -composing.distance(from: cursor, to: composing.endIndex)
        if length > 0 {
            frontend.composeString(composing, candidateStart: start, candidateLength: length)
        } else {
            frontend.composeString(composing, cursorOffset: offset)
        }
        currentDisplayString = composing
    }

    @objc public var isComposing: Bool {
        !composing.isEmpty
    }
}
