//
//  StateMachine.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/08.
//






// MARK: - Deferred event

struct GenericDeferEvent {
    func enqueue(handler _: HandlerProtocol, event _: GenericEvent) {}
    func dequeeue(key _: HandlerProtocol) -> GenericEvent? { nil }

    func commit(key _: HandlerProtocol) {}
}

// MARK: - Empty Inspector
protocol InspectorProtocol {
    associatedtype Handler: HandlerProtocol
    func inspect(handler: Handler, event: GenericEvent)
}

// MARK: - State Machine

protocol HandlerProtocol: Equatable {
    func invoke(event: GenericEvent) -> GenericState<Self>?
}

struct StubHandler: HandlerProtocol {
    func invoke(event: GenericEvent) -> GenericState<StubHandler>? {
        fatalError()
    }
}


// MARK: - Base State Container

struct BaseStateContainer {}
