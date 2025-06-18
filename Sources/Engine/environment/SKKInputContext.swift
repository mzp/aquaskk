//
//  SKKInputContext.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/13.
//
import AquaSKKBackend

public class SKKInputContextImpl {
    var entry: SKKEntryBridge
    var candidate: SKKCandidateBridge
    let output: SKKOutputBufferImpl
    let undo: SKKUndoContextImpl
    let registration: SKKRegistrationImpl

    var event_handled = false
    var needs_setback = false
    var dynamic_completion = false
    var annotation = false

    public init(frontend: SKKFrontEndProtocol) {
        entry = SKKEntryBridge()
        candidate = SKKCandidateBridge()
        output = SKKOutputBufferImpl(frontend: frontend)
        undo = SKKUndoContextImpl(frontend: frontend)
        registration = SKKRegistrationImpl()
    }

    var candidateBridge: SKKCandidateBridge {
        candidate
    }
}
