//
//  SKKStateMachineEvent.swift
//  AquaSKKInput
//
//  Created by mzp on 2025/05/25.
//

public struct SKKStateMachineEvent {
    var id: SKKEventID
    var param: SKKEventImpl

    init(_ rawValue: Int32) {
        id = .init(rawValue: rawValue)!
        param = .init()
    }

    init(_ rawValue: Int32, _ payload: SKKEventImpl) {
        id = .init(rawValue: rawValue)!
        param = payload
    }

    init(id: SKKEventID, param: SKKEventImpl) {
        self.id = id
        self.param = param
    }

    func IsSystem() -> Bool {
        id == .exitEvent || id == .initEvent || id == .entryEvent || id == .probeEvent
    }

    func IsUser() -> Bool {
        return !IsSystem()
    }
}
