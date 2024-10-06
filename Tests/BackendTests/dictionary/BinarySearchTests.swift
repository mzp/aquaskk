//
//  BinarySearchTests.swift
//  UITests
//
//  Created by mzp on 10/6/24.
//

import Testing
@testable internal import AquaSKKBackend

struct BinarySearchTests {
    let xs = [1, 2, 4, 5, 6, 7, 8, 9 ,10]
    @Test func notFound() {
        #expect(binarySearch(3, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == nil)
        #expect(binarySearch(0, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == nil)
        #expect(binarySearch(11, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == nil)
    }
    @Test func found() {
        #expect(binarySearch(4, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == 4)

    }
    @Test func edge() {
        #expect(binarySearch(1, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == 1)
        #expect(binarySearch(10, from: xs, startIndex: xs.startIndex, endIndex: xs.endIndex, by: <) == 10)
    }
}
