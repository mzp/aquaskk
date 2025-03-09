//
//  StateType.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/09.
//


// MARK: - State

enum StateType {
    case unknown
    case super_
    case initial
    case transition
    case saveHistory
    case shalllowHistory
    case deepHistory
    case forward
    case deepForward
    case deferEvent
    case clearHistory
}

struct GenericState<Handler: HandlerProtocol> {
    var type: StateType
    var handler: Handler

    init(type: StateType, handler: Handler) {
        self.type = type
        self.handler = handler
    }

    static func initial(handler: Handler) -> GenericState {
        .init(type: .initial, handler: handler)
    }

    static func super_(handler: Handler) -> GenericState {
        .init(type: .super_, handler: handler)
    }
}