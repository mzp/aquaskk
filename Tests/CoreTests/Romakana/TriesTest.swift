//
//  TriesTest.swift
//  CoreTests
//
//  Created by mzp on 8/12/24.
//

@testable import AquaSKKCore
import Testing

struct TriesTest {
    func createTrie() -> Trie<String> {
        var root = Trie<String>()
        root.add("あ", forKey: "a")
        root.add("きゃ", forKey: "kya")
        root.add("か", forKey: "ka")
        root.add("ん", forKey: "n")
        root.add("ん", forKey: "nn")
        root.add("っ", forKey: "xx")
        return root
    }

    @Test func empty() {
        let root = Trie<String>()
        let input = TrieInput("a")
        #expect(root.traverse(input: input) == .character("a"))
        #expect(input.isEmpty)
    }

    @Test func converted() {
        let root = createTrie()
        let input = TrieInput("a")
        #expect(root.traverse(input: input) == .value("あ"))
        #expect(input.isEmpty)
    }

    @Test func notConrverted() {
        let root = createTrie()
        let input = TrieInput("m")
        #expect(root.traverse(input: input) == .character("m"))
        #expect(input.isEmpty)
    }

    @Test("Recursive search", arguments: [
        ("kya", "きゃ"),
        ("nn", "ん"),
        ("xx", "っ")
    ]) func recurvise(input: String, expect: String) {
        let root = createTrie()
        let input = TrieInput(input)
        #expect(root.traverse(input: input) == .value(expect))
        #expect(input.isEmpty)
    }

    @Test("Intermediate state", arguments: [
        ("ky", nil),
        ("n", "ん")
    ]) func intermediate(input: String, expect: String?) {
        let root = createTrie()
        let input = TrieInput(input)
        #expect(root.traverse(input: input) == .intermediate(expect))
        #expect(input.offset == 0)
    }

    @Test func partialConsume() {
        let root = createTrie()
        let input = TrieInput("ng")
        #expect(root.traverse(input: input) == .value("ん"))
        #expect(input.offset == 1)
    }

    @Test func consume() {
        let root = createTrie()
        let input = TrieInput("ki")
        #expect(root.traverse(input: input) == .value())
        #expect(input.offset == 1)
    }
}
