//
//  SKKAttribute.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/15.
//

import Foundation

/// SKK_CHAR 属性
public struct SKKAttribute: OptionSet, Equatable {
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

@objc public class SKKAttributeValue: NSObject {
    @objc public static let noneAttribute = SKKAttribute.noneAttribute.rawValue
    @objc public static let direct = SKKAttribute.direct.rawValue
    @objc public static let upperCases = SKKAttribute.upperCases.rawValue
    @objc public static let toggleKana = SKKAttribute.toggleKana.rawValue
    @objc public static let toggleJisx0201Kana = SKKAttribute.toggleJisx0201Kana.rawValue
    @objc public static let switchToAscii = SKKAttribute.switchToAscii.rawValue
    @objc public static let switchToJisx0208Latin = SKKAttribute.switchToJisx0208Latin.rawValue
    @objc public static let enterJapanese = SKKAttribute.enterJapanese.rawValue
    @objc public static let enterAbbrev = SKKAttribute.enterAbbrev.rawValue
    @objc public static let nextCompletion = SKKAttribute.nextCompletion.rawValue
    @objc public static let prevCompletion = SKKAttribute.prevCompletion.rawValue
    @objc public static let nextCandidate = SKKAttribute.nextCandidate.rawValue
    @objc public static let prevCandidate = SKKAttribute.prevCandidate.rawValue
    @objc public static let removeTrigger = SKKAttribute.removeTrigger.rawValue
    @objc public static let inputChars = SKKAttribute.inputChars.rawValue
    @objc public static let compConversion = SKKAttribute.compConversion.rawValue
    @objc public static let stickyKey = SKKAttribute.stickyKey.rawValue
}
