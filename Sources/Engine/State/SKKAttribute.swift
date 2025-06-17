//
//  SKKAttribute.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/15.
//

import Foundation

/// SKK_CHAR 属性
public struct SKKAttribute: OptionSet {
    public let rawValue: Int

    public static let noneAttribute = SKKAttribute(rawValue: 0)
    public static let direct = SKKAttribute(rawValue: 1 << 0)
    public static let upperCases = SKKAttribute(rawValue: 1 << 1)
    public static let toggleKana = SKKAttribute(rawValue: 1 << 2)
    public static let toggleJisx0201Kana = SKKAttribute(rawValue: 1 << 3)
    public static let switchToAscii = SKKAttribute(rawValue: 1 << 4)
    public static let switchToJisx0208Latin = SKKAttribute(rawValue: 1 << 5)
    public static let enterJapanese = SKKAttribute(rawValue: 1 << 6)
    public static let enterAbbrev = SKKAttribute(rawValue: 1 << 7)
    public static let nextCompletion = SKKAttribute(rawValue: 1 << 8)
    public static let prevCompletion = SKKAttribute(rawValue: 1 << 9)
    public static let nextCandidate = SKKAttribute(rawValue: 1 << 10)
    public static let prevCandidate = SKKAttribute(rawValue: 1 << 11)
    public static let removeTrigger = SKKAttribute(rawValue: 1 << 12)
    public static let inputChars = SKKAttribute(rawValue: 1 << 13)
    public static let compConversion = SKKAttribute(rawValue: 1 << 14)
    public static let stickyKey = SKKAttribute(rawValue: 1 << 15)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public class SKKAttributeValue {
    public static let noneAttribute = SKKAttribute.noneAttribute.rawValue
    public static let direct = SKKAttribute.direct.rawValue
    public static let upperCases = SKKAttribute.upperCases.rawValue
    public static let toggleKana = SKKAttribute.toggleKana.rawValue
    public static let toggleJisx0201Kana = SKKAttribute.toggleJisx0201Kana.rawValue
    public static let switchToAscii = SKKAttribute.switchToAscii.rawValue
    public static let switchToJisx0208Latin = SKKAttribute.switchToJisx0208Latin.rawValue
    public static let enterJapanese = SKKAttribute.enterJapanese.rawValue
    public static let enterAbbrev = SKKAttribute.enterAbbrev.rawValue
    public static let nextCompletion = SKKAttribute.nextCompletion.rawValue
    public static let prevCompletion = SKKAttribute.prevCompletion.rawValue
    public static let nextCandidate = SKKAttribute.nextCandidate.rawValue
    public static let prevCandidate = SKKAttribute.prevCandidate.rawValue
    public static let removeTrigger = SKKAttribute.removeTrigger.rawValue
    public static let inputChars = SKKAttribute.inputChars.rawValue
    public static let compConversion = SKKAttribute.compConversion.rawValue
    public static let stickyKey = SKKAttribute.stickyKey.rawValue
}
