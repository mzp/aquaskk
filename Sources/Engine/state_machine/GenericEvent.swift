//
//  GenericEvent.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

struct GenericEvent {
    var signal: SKKEventID
    var event: SKKEvent?

    static let exit: GenericEvent = .init(signal: SKKEventID.exitEvent)
    static let init_: GenericEvent = .init(signal: .initEvent)
    static let entry: GenericEvent = .init(signal: .entryEvent)
    static let probe: GenericEvent = .init(signal: .probeEvent)
}

extension SKKEventID: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }
    public var debugDescription: String {
        switch self {
        case .asciiMode:
            return "asciiMode"
        case .exitEvent:
            return "exitEvent"
        case .initEvent:
            return "initEvent"
        case .entryEvent:
            return "entryEvent"
        case .probeEvent:
            return "probeEvent"
        case .null:
            return "null"
        case .jmode:
            return "jMode"
        case .enter:
            return "enter"
        case .cancel:
            return "cancel"
        case .backspace:
            return "backspace"
        case .delete_:
            return "delete"
        case .tab:
            return "tab"
        case .paste:
            return "paste"
        case .left:
            return "left"
        case .right:
            return "right"
        case .up:
            return "up"
        case .down:
            return "down"
        case .charInput:
            return "char"
        case .ping:
            return "ping"
        case .undo:
            return "undo"
        case .hirakanaMode:
            return "hirakanaMode"
        case .katakanaMode:
            return "katakanaMode"
        case .jisx0201KanaMode:
            return "jisx0201KanaMode"
        case .jisx0208LatinMode:
            return "jisx0208LatinMode"
        case .yes:
            return "yes"
        case .no:
            return "no"
        case .on:
            return "on"
        case .off:
            return "off"
        @unknown default:
            return "unknown"
        }
    }
}
