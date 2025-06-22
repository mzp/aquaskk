//
//  SKKEvent.swift
//  AquaSKK
//
//  Created by mzp on 2025/06/20.
//

public struct SKKEventImpl: Equatable {
    public var id: SKKEventID
    public var attribute: SKKAttribute
    public var option: SKKHandleOption
    public var code: Int

    public init() {
        id = .probeEvent
        attribute = []
        option = .defalutOption
        code = 0
    }

    public init(id: SKKEventID, code: Int, attribute: SKKAttribute = [], option: SKKHandleOption = .defalutOption)
    {
        self.id = id
        self.code = code
        self.attribute = attribute
        self.option = option
    }

    var isDirect: Bool {
        return attribute.contains(.direct)
    }

    var isUpperCases: Bool {
        return attribute.contains(.upperCases)
    }

    var isToggleKana: Bool {
        return attribute.contains(.toggleKana)
    }

    var isToggleJisx0201Kana: Bool {
        return attribute.contains(.toggleJisx0201Kana)
    }

    var isSwitchToAscii: Bool {
        return attribute.contains(.switchToAscii)
    }

    var isSwitchToJisx0208Latin: Bool {
        return attribute.contains(.switchToJisx0208Latin)
    }

    var isEnterJapanese: Bool {
        return attribute.contains(.enterJapanese)
    }

    var isEnterAbbrev: Bool {
        return attribute.contains(.enterAbbrev)
    }

    var isNextCompletion: Bool {
        return attribute.contains(.nextCompletion)
    }

    var isPrevCompletion: Bool { return attribute.contains(.prevCompletion) }
    var isNextCandidate: Bool {
        return attribute.contains(.nextCandidate)
    }

    var isPrevCandidate: Bool {
        return attribute.contains(.prevCandidate)
    }

    var isRemoveTrigger: Bool {
        return attribute.contains(.removeTrigger)
    }

    var isInputChars: Bool {
        return attribute.contains(.inputChars)
    }

    var isCompConversion: Bool {
        return attribute.contains(.compConversion)
    }

    var isStickyKey: Bool {
        return attribute.contains(.stickyKey)
    }

    static let null: SKKEventImpl = .init(id: .null, code: 0, attribute: [], option: .defalutOption)

    public var description: String { "" }
}
