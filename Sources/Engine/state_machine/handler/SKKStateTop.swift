//
//  SKKStateTop.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/30.
//

class SKKStateTop: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil
    func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .initEvent:
            return .initializePrimary
        default:
            return .handled
        }
    }
}
