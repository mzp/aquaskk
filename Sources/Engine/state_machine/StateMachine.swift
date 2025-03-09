//
//  StateMachine.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/08.
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
}

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
};

struct GenericState {
    var type: StateType

    static func initial(handler: HandlerProtocol) -> GenericState {
        .init(type: .initial)
    }
}

// MARK: - Deferred event
struct GenericdeferEvent {}

// MARK: - Empty Inspector
struct EmptyInspector {}

// MARK: - State Machine
protocol HandlerProtocol {
}
struct StubHandler: HandlerProtocol {}
struct GenericStateMachine<Handler: HandlerProtocol> {
    // &StateContainer::TopState
    var top: HandlerProtocol = StubHandler()
    var active: HandlerProtocol?

    public func start() {
        assert(active == nil, "*** You can not call Start() twice ***")
        initialize(target: GenericState.initial(handler: top))
    }

    func initialize(target: GenericState) {

    }

    var selfTransitionCount = 0
    mutating public func dispatch() {
        if active == nil {
            start()
        }
        selfTransitionCount = 0
    }
}

// MARK: - Base State Container
struct BaseStateContainer {}
