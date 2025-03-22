//
//  SKKTextBuffer.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/03.
//

/// カーソル移動をサポートするテキストバッファ
public struct SKKTextBufferImpl {
    private var content: String
    private var index: String.Index

    public init() {
        content = ""
        index = content.startIndex
    }

    // MARK: - Content

    public var string: String { content }

    public var leftString: String { String(content[..<index]) }
    public var rightString: String { String(content[index ..< string.endIndex]) }
    public var isEmpty: Bool { content.isEmpty }

    // MARK: - Mutating

    public mutating func insert(_ str: String) {
        content.insert(contentsOf: str, at: index)
        index = string.index(index, offsetBy: str.count)
    }

    public mutating func backSpace() {
        if index == content.startIndex {
            return
        }
        cursorLeft()
        content.remove(at: index)
    }

    public mutating func delete() {
        if index == string.endIndex {
            return
        }
        content.remove(at: index)
    }

    public mutating func clear() {
        content = ""
        index = content.startIndex
    }

    // MARK: - Cursor Position

    public var cursorPosition: Int {
        -content.distance(from: index, to: content.endIndex)
    }

    public mutating func cursorLeft() {
        if index != content.startIndex {
            index = content.index(index, offsetBy: -1)
        }
    }

    public mutating func cursorRight() {
        if index != content.endIndex {
            index = content.index(index, offsetBy: 1)
        }
    }

    public mutating func cursorUp() {
        index = content.startIndex
    }

    public mutating func cursorDown() {
        index = content.endIndex
    }
}

extension SKKTextBufferImpl: Equatable {
    public static func == (lhs: SKKTextBufferImpl, rhs: SKKTextBufferImpl) -> Bool {
        return lhs.string == rhs.string
    }
}
