//
//  GenericState.swift
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

    static func super_(handler: Handler) -> GenericState {
        .init(type: .super_, handler: handler)
    }

    static func initial(handler: Handler) -> GenericState {
        .init(type: .initial, handler: handler)
    }

    static func transition(handler: Handler) -> GenericState {
        return .init(type: .transition, handler: handler)
    }

    static func saveHistory(handler: Handler) -> GenericState {
        return .init(type: .saveHistory, handler: handler)
    }

    static func shalllowHistory(handler: Handler) -> GenericState {
        return .init(type: .shalllowHistory, handler: handler)
    }

    static func deepHistory(handler: Handler) -> GenericState {
        return .init(type: .deepHistory, handler: handler)
    }

    static func forward(handler: Handler) -> GenericState {
        return .init(type: .forward, handler: handler)
    }

    static func deepForward(handler: Handler) -> GenericState {
        return .init(type: .deepForward, handler: handler)
    }

    static func deferEvent(handler: Handler) -> GenericState {
        return .init(type: .deferEvent, handler: handler)
    }

    static func clearHistory(handler: Handler) -> GenericState {
        return .init(type: .clearHistory, handler: handler)
    }
}
