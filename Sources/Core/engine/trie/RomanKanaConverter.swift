//
//  RomanKanaConverter.swift
//  AquaSKKCore
//
//  Created by mzp on 8/12/24.
//
import OSLog

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Core", category: "Romankana")

struct RomanKanaRule: Equatable, Hashable {
    var hirakana: String
    var katakana: String
    var jisx0201kana: String
    var next: String

    func kanaString(for inputMode: SKKInputMode) -> String {
        switch inputMode {
        case .HirakanaInputMode:
            return hirakana
        case .KatakanaInputMode:
            return katakana
        case .Jisx0201KanaInputMode:
            return jisx0201kana
        default:
            logger.error("invalid input mode: \(inputMode.rawValue)")
            return ""
        }
    }
}

@objc(AICRomanKanaResult) class RomanKanaResult: NSObject {
    @objc var output: String = ""
    @objc var intermediate: String = ""
    @objc var next: String = ""
    @objc var converted: Bool = false
}

@objc(AICRomanKanaConverter)
class RomanKanaConverter: NSObject {
    var root = Trie<RomanKanaRule>()

    @objc(initWithPath:error:)
    init(path: String) throws {
        super.init()
        try append(path: path)
    }

    @objc(appendPath:error:)
    func append(path: String) throws {
        logger.log("\(#function): Load \(path)")
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        guard let content = String(data: data, encoding: .japaneseEUC) else {
            return
        }
        for (n, line) in content.components(separatedBy: .newlines).enumerated() {
            if line.hasPrefix("#") || line.isEmpty {
                continue
            }
            let rows = line.components(separatedBy: ",").map {
                unescape($0)
            }

            if rows.count < 4 || rows.count > 5 {
                logger.error("Invalid format: \(line) at \(n)")
            } else {
                let roman = rows[0]
                let rule = RomanKanaRule(
                    hirakana: rows[1],
                    katakana: rows[2],
                    jisx0201kana: rows[3],
                    next: rows.count < 5 ? "" : rows[4]
                )
                root.add(rule, forKey: roman)
            }
        }
    }

    /// ローマ字かな変換
    ///
    /// @param mode 入力モード
    /// @param input ローマ字文字列
    /// @param state 変換結果
    /// @return 変換に成功した場合はtrue、さもなければfalse
    @objc(convert:inputMode:) func convert(_ string: String, inputMode: SKKInputMode) -> RomanKanaResult? {
        let result = RomanKanaResult()

        let input = TrieInput(string)
        while !input.isEmpty {
            switch root.traverse(input: input) {
            case let .character(character):
                // XXX: 本当に上書きしていいの?
                result.converted = false
                result.output += String(character)

            case let .value(node):
                if let node = node {
                    result.output += node.kanaString(for: inputMode)
                    result.intermediate.removeAll()
                    result.next = node.next
                }
                result.converted = true

            case let .intermediate(node):
                if let node = node {
                    result.intermediate = node.kanaString(for: inputMode)
                }
                result.next = input.remain
                return result
            }
        }
        return result
    }

    private func unescape(_ string: String) -> String {
        var result = string
        for (escaped, original) in [
            ("&comma;", ","),
            ("&space;", " "),
            ("&sharp;", "#"),
        ] {
            result.replace(escaped, with: original)
        }
        return result
    }
}
