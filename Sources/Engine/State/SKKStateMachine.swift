//
//  SKKStateMachine.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/09.
//

import AquaSKKLogging
import OSLog

public class SKKStateMachineImpl {
    let machine: GenericStateMachine<SKKStateTop>

    public init() {
        machine = GenericStateMachine(top: SKKStateTop(), inspector: DebugInspector())
    }

    public func dispatch(event: SKKEvent) {
        let genericEvent: GenericEvent = .init(signal: SKKEventID(rawValue: event.id) ?? SKKEventID.null)
        machine.dispatch(event: genericEvent)
    }
}

struct DebugInspector: InspectorProtocol {
    func inspect(handler: any HandlerProtocol, event _: GenericEvent) {
        Logger.skkState.debug("[\(#fileID, privacy: .public):\(#function, privacy: .public)] \(handler.handlerID, privacy: .private)")
    }
}
