//
//  Trie.swift
//  AquaSKKCore
//
//  Created by mzp on 8/12/24.
//

enum TrieResult<T: Equatable>: Equatable {
    /// 変換結果
    case value(_: T? = nil)
    /// 未変換結果
    case character(_: Character)

    /// 途中結果 + データ不足
    case intermediate(_: T? = nil)
}

class TrieInput {
    private var index: String.Index
    private var string: String

    init(_ string: String) {
        index = string.startIndex
        self.string = string
    }

    var count: Int { string.count }
    var offset: Int {
        string.distance(from: string.startIndex, to: index)
    }

    var isEmpty: Bool {
        index == string.endIndex
    }

    subscript(offset: Int) -> Character {
        let index = string.index(self.index, offsetBy: offset)
        return string[index]
    }

    func skip(_ offset: Int) {
        index = string.index(index, offsetBy: offset)
    }

    var remain: String {
        String(string[index ..< string.endIndex])
    }
}

struct Trie<T: Equatable> {
    var value: T? = nil
    var children: [Character: Trie<T>] = [:]

    var isLeaf: Bool {
        value != nil
    }

    mutating func add(_ value: T, forKey key: String, depth: Int = 0) {
        let index = key.index(key.startIndex, offsetBy: depth)

        if index == key.endIndex {
            self.value = value
        } else {
            let character = key[index]
            var entry = children[character] ?? Trie()
            entry.add(value, forKey: key, depth: depth + 1)
            children[character] = entry
        }
    }

    func traverse(input: TrieInput, depth: Int = 0) -> TrieResult<T> {
        if depth == input.count {
            // [1] データ不足(ex. "k" や "ch" など)
            return .intermediate(value)
        } else if let node = children[input[depth]] {
            // 一致？

            // 末端でないなら再帰検索
            if !node.children.isEmpty {
                return node.traverse(input: input, depth: depth + 1)
            } else {
                // [2] 完全一致
                input.skip(depth + 1)
                return .value(node.value)
            }
        } else if depth > 0 {
            // [3] 部分一致(ex. "kb" や "chm" など)
            input.skip(depth)
            return .value(value)
        } else {
            let character = input[0]
            // [4] 最初の一文字が木に存在しない
            input.skip(1)
            return .character(character)
        }
    }
}
