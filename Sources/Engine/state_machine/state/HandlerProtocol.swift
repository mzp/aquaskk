//
//  HandlerProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/29.
//

protocol HandlerProtocol {
    var handlerID: String { get }
    var super_: (any HandlerProtocol)? { get set }

    func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction
}
