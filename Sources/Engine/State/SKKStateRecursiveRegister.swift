//
//  SKKStateRecursiveRegister.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/14.
//

/// level 1：単語削除
public class SKKStateRecursiveRegister: HandlerProtocol {
    var super_: HandlerProtocol?

    var handlerID: String { NSStringFromClass(Self.self) as String }
    var editor: SKKInputEngineImpl
    var messenger: SKKMessengerProtocol
    init(editor: SKKInputEngineImpl, messenger: SKKMessengerProtocol) {
        self.editor = editor
        self.messenger = messenger
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.setStateRegistration()
            messenger.beep()
            return .handled

        case .enter:
            return .transitionKanaInput

        case .cancel:
            return .deepHistoryComposing

        default:
            return .super_
        }
    }
}
