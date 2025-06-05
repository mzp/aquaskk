//
//  RomanKanaConverter.swift
//  AquaSKKEngine
//
//  Created by mzp on 8/12/24.
//
import AquaSKKLogging
import OSLog

struct SKKRomanKanaRule: Equatable, Hashable {
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
            Logger.skkEngine.error("invalid input mode: \(inputMode.rawValue, privacy: .public)")
            return ""
        }
    }
}

@objc(SKKRomanKanaResult)
public class SKKRomanKanaResult: NSObject {
    @objc public var output: String = ""
    @objc public var intermediate: String = ""
    @objc public var next: String = ""
    @objc public var converted: Bool = false
}

@objc(SKKRomanKanaConverterImpl)
public class SKKRomanKanaConverterImpl: NSObject {
    var root = Trie<SKKRomanKanaRule>()

    static let sharedInstance = SKKRomanKanaConverterImpl()

    @objc(sharedInstance) public static func shared() -> SKKRomanKanaConverterImpl {
        return sharedInstance
    }

    @objc(initialize:) public func initialize(from path: String) {
        do {
            root = Trie<SKKRomanKanaRule>()
            try append(path: path)
        } catch {
            Logger.skkEngine.error("\(#function, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc(patch:) public func patch(from path: String) {
        do {
            try append(path: path)
        } catch {
            Logger.skkEngine.error("\(#function, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    func append(path: String) throws {
        Logger.skkEngine.log("\(#function, privacy: .public): Load \(path, privacy: .private)")
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
                Logger.skkEngine.error("Invalid format: \(line, privacy: .private) at \(n, privacy: .private)")
            } else {
                let roman = rows[0]
                let rule = SKKRomanKanaRule(
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
    /// @param string ローマ字文字列
    /// @param inputMode 入力モード
    /// @return 変換結果
    @objc(convert:inputMode:)
    public func convert(_ string: String, inputMode: SKKInputMode) -> SKKRomanKanaResult? {
        let result = SKKRomanKanaResult()

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
