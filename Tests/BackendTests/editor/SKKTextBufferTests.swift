//
//  SKKTextBufferTests.swift
//  BackendTests
//
//  Created by mzp on 2025/03/03.
//

import Testing
@testable internal import AquaSKKEngine

struct SKKTextBufferTests {
    var buffer = SKKTextBufferImpl()

    init() {
        buffer.insert("abc")
    }

    @Test mutating func backspace() {
        #expect(buffer.string == "abc")

        buffer.backSpace()
        #expect(buffer.string == "ab")
    }

    @Test mutating func delete() {
        buffer.cursorUp()
        buffer.delete()
        #expect(buffer.string == "bc")
    }

    @Test mutating func clear() {
        buffer.clear()
        #expect(buffer.string == "")
    }

    @Test mutating func isEmpty() {
        #expect(!buffer.isEmpty)

        let buf = SKKTextBufferImpl()
        #expect(buf.isEmpty)
    }

    @Test mutating func equal() {
        var buffer2 = SKKTextBufferImpl()
        buffer2.insert("abc")
        buffer2.cursorUp()
        #expect(buffer == buffer2)
    }

    @Test mutating func insert() {
        buffer.insert("def")
        #expect(buffer.cursorPosition == 0)
    }

    @Test mutating func cursorPosition() {
        #expect(buffer.cursorPosition == 0)

        buffer.cursorLeft()
        #expect(buffer.cursorPosition == -1)
        buffer.cursorUp()
        #expect(buffer.cursorPosition == -3)
        buffer.cursorDown()
        #expect(buffer.cursorPosition == 0)
    }

    @Test mutating func string() {
        buffer.cursorLeft()
        #expect(buffer.leftString == "ab")
        #expect(buffer.rightString == "c")
    }
    // void Insert(const std::string &str);
    // void BackSpace();
    // void Delete();
    // void Clear();
    //
    // void CursorLeft();
    // void CursorRight();
    // void CursorUp();
    // void CursorDown();
    //
    // int CursorPosition() const;
    //
    // bool IsEmpty() const;
    //
    // bool operator==(const std::string &str) const;
    //
    // std::string String() const;
    // std::string LeftString() const;
    // std::string RightString() const;
}
