//
//  GenericEvent.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//

// MARK: - Event types

enum EventType {
    case exit
    case init_
    case entry
    case probe
    case user
}

// MARK: - Event

struct GenericEvent {
    var signal: EventType

    static let exit: GenericEvent = .init(signal: .exit)
    static let init_: GenericEvent = .init(signal: .init_)
    static let entry: GenericEvent = .init(signal: .entry)
    static let probe: GenericEvent = .init(signal: .probe)
}
