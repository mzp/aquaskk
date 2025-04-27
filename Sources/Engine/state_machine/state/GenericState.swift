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

class EmptyHandler: HandlerProtocol {
    var handlerID: String { "EmptyHandler" }
    var super_: HandlerProtocol? = nil
    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        return .super_
    }
}

struct GenericState {
    var type: StateType
    var handler: any HandlerProtocol

    init(type: StateType, handler: any HandlerProtocol) {
        self.type = type
        self.handler = handler
    }

    static func super_(handler: HandlerProtocol) -> GenericState {
        .init(type: .super_, handler: handler)
    }

    static func initial(handler: HandlerProtocol) -> GenericState {
        .init(type: .initial, handler: handler)
    }

    static func transition(handler: HandlerProtocol) -> GenericState {
        return .init(type: .transition, handler: handler)
    }

    static func saveHistory() -> GenericState {
        return .init(type: .saveHistory, handler: EmptyHandler())
    }

    static func shalllowHistory(handler: HandlerProtocol) -> GenericState {
        return .init(type: .shalllowHistory, handler: handler)
    }

    static func deepHistory(handler: HandlerProtocol) -> GenericState {
        return .init(type: .deepHistory, handler: handler)
    }

    static func forward(handler: HandlerProtocol) -> GenericState {
        return .init(type: .forward, handler: handler)
    }

    static func deepForward(handler: HandlerProtocol) -> GenericState {
        return .init(type: .deepForward, handler: handler)
    }

    static func deferEvent(handler: HandlerProtocol) -> GenericState {
        return .init(type: .deferEvent, handler: handler)
    }

    static func clearHistory(handler: HandlerProtocol) -> GenericState {
        return .init(type: .clearHistory, handler: handler)
    }
}
