//
//  RomanKanaConverter.swift
//  AquaSKKCore
//
//  Created by mzp on 8/12/24.
//
import OSLog

struct RomanKanaRule: Equatable, Hashable {
    var hirakana: String
    var katakana: String
    var jisx0201kana: String
    var next: String?
}

private let logger = Logger(subsystem: "org.codefirst.AquaSKK.Core", category: "Romankana")

class RomanKanaConverter {
    var root = Trie<RomanKanaRule>()

    init(path: String) throws {
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
                    next: rows.count < 5 ? nil : rows[4]
                )
                root.add(rule, forKey: roman)
            }
        }
    }

    func Patch(_: String) {}

    /// ローマ字かな変換
    ///
    /// @param mode 入力モード
    /// @param input ローマ字文字列
    /// @param state 変換結果
    /// @return 変換に成功した場合はtrue、さもなければfalse
    func Convert(_: SKKInputMode, _: String, _: inout SKKRomanKanaConversionResult) -> Bool {
        return false
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
