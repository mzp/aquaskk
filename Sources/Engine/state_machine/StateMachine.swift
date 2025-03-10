///
///  StateMachine.swift
///  AquaSKK
///
///  Created by mzp on 2025/03/08.
///

protocol InspectorProtocol {
    associatedtype Handler: HandlerProtocol
    func inspect(handler: Handler, event: GenericEvent)
}

protocol HandlerProtocol: Equatable {
    func invoke(event: GenericEvent) -> GenericState<Self>?
}
