//
//  NumericConverter.swift
//  AquaSKKBackend
//
//  Created by mzp on 9/14/24.
//

import Foundation

public class NumericConverter {
    var params = [String.UnicodeScalarView]()
    private(set) var original: String = ""
    var normalized: String = ""

    public func setup(_ query: String) -> Bool {
        params.removeAll()
        original = query

        var src = query.unicodeScalars
        let numbers = CharacterSet(charactersIn: "0123456789")
        var from = src.firstIndex {
            numbers.contains($0)
        }

        // 連続した数値を見つけたら vector に格納し、"#" に正規化
        while from != nil {
            let to = src[from!...].firstIndex(where: {
                !numbers.contains($0)
            }) ?? src.endIndex
            params.append(String.UnicodeScalarView(src[from! ..< to]))
            src.replaceSubrange(from! ..< to, with: "#".unicodeScalars)
            from = src[src.index(after: from!)...].firstIndex {
                numbers.contains($0)
            }
        }

        normalized = String(src)
        return !params.isEmpty
    }

    public var originalKey: String { original }
    public var normalizedKey: String {
        if params.isEmpty {
            return original
        } else {
            return normalized
        }
    }

    public func apply(candidate: inout SKKCandidate) {
        guard !params.isEmpty else {
            return
        }
        let numbers = CharacterSet(charactersIn: "0123459")

        var src = String(candidate.word).unicodeScalars
        var pos = src.startIndex

        for param in params {
            guard let found = src[(src.index(after: pos))...].firstIndex(where: {
                numbers.contains($0)
            }) else {
                break
            }
            if src[src.index(before: found)] == "#" {
                switch src[found] {
                case "0":
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: param)

                case "1":
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType1(param))

                case "2":
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType2(param))

                case "3":
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType3(param))

                case "4": // 数値再変換(AquaSKK では無変換)
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType4(param))

                case "5": // 小切手・手形
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType5(param))

                case "9": // 棋譜入力用
                    let start = src.index(before: found)
                    src.replaceSubrange(start ... found, with: Self.convertType9(param))

                default:
                    ()
                }
            }
            guard let next = src.index(found, offsetBy: param.count - 1, limitedBy: src.endIndex) else {
                break
            }
            pos = next
        }
        candidate.variant = std.string(String(src))
    }

    public init() {}

    static func convertType1(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        var result = ""

        for c in src {
            switch c {
            case "0":
                result += "０"

            case "1":
                result += "１"

            case "2":
                result += "２"

            case "3":
                result += "３"

            case "4":
                result += "４"

            case "5":
                result += "５"

            case "6":
                result += "６"

            case "7":
                result += "７"

            case "8":
                result += "８"

            case "9":
                result += "９"

            default:
                ()
            }
        }
        return result.unicodeScalars
    }

    /// 1024 → 一〇二四
    static func convertType2(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        var result = ""

        for c in src {
            switch c {
            case "0":
                result += "〇"

            case "1":
                result += "一"

            case "2":
                result += "二"

            case "3":
                result += "三"

            case "4":
                result += "四"

            case "5":
                result += "五"

            case "6":
                result += "六"

            case "7":
                result += "七"

            case "8":
                result += "八"

            case "9":
                result += "九"

            default:
                ()
            }
        }

        return result.unicodeScalars
    }

    /// 1024 → 千二十四
    static func convertType3(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        let unit1 = ["", "万", "億", "兆", "京", "垓"]
        let unit2 = ["十", "百", "千"]
        var result = ""
        var previousSize = 0

        if src.count == 1 && src.first == "0" {
            return "〇".unicodeScalars
        }

        for (i, c) in src.enumerated().drop(while: { $0.element == "0" }) {
            switch c {
            case "2":
                result += "二"

            case "3":
                result += "三"

            case "4":
                result += "四"

            case "5":
                result += "五"

            case "6":
                result += "六"

            case "7":
                result += "七"

            case "8":
                result += "八"

            case "9":
                result += "九"

            default:
                ()
            }

            var distance = src.count - i

            if distance > 4 && (distance - 1) % 4 == 0 {
                if c == "1" {
                    result += "一"
                }
                // 「垓、京、兆、億、万」が連続しない場合に追加
                if previousSize < result.count {
                    result += unit1[(distance - 1) / 4]
                    previousSize = result.count
                }
            } else {
                // 十の位以上
                if distance > 1 {
                    if c != "0" {
                        // 「一千万」の処理
                        if c == "1" && distance > 4 && (distance - 2) % 4 == 2 {
                            result += "一"
                        }
                        result += unit2[(distance - 2) % 4]
                    }
                } else {
                    // 一の位
                    if c == "1" {
                        result += "一"
                    }
                }
            }
        }
        return result.unicodeScalars
    }

    /// 数値再変換(AquaSKK では無視)
    static func convertType4(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        return src
    }

    /// 1024 → 壱阡弐拾四
    static func convertType5(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        let unit1 = ["", "萬", "億", "兆", "京", "垓"]
        let unit2 = ["拾", "百", "阡"]
        var result = ""
        var previousSize = 0

        if src.count == 1 && src.first == "0" {
            return "零".unicodeScalars
        }

        for (i, c) in src.enumerated().drop(while: { $0.element == "0" }) {
            switch c {
            case "1":
                result += "壱"
            case "2":
                result += "弐"
            case "3":
                result += "参"
            case "4":
                result += "四"
            case "5":
                result += "伍"
            case "6":
                result += "六"
            case "7":
                result += "七"
            case "8":
                result += "八"
            case "9":
                result += "九"
            default:
                ()
            }

            let distance = src.count - i

            // 「十、百、千」以外の位
            if distance > 4 && (distance - 1) % 4 == 0 {
                // 「垓、京、兆、億、萬」が連続しない場合に追加
                if previousSize < result.count {
                    result += unit1[(distance - 1) / 4]
                    previousSize = result.count
                }
            } else {
                // 十の位以上
                if distance > 1 {
                    if c != "0" {
                        result += unit2[(distance - 2) % 4]
                    }
                }
            }
        }

        return result.unicodeScalars
    }

    /// 34 → ３四
    static func convertType9(_ src: String.UnicodeScalarView) -> String.UnicodeScalarView {
        let first = src.startIndex
        let second = src.index(after: first)
        let third = src.index(after: second)

        return convertType1(.init(src[first ..< second])) + convertType2(.init(src[second ..< third]))
    }
}
