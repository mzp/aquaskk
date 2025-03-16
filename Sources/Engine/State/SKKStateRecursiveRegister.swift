//
//  SKKStateRecursiveRegister.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/14.
//

import Foundation

/// level 1：単語削除
public class SKKStateRecursiveRegister {
    var editor: SKKInputEngine
    var messenger: SKKMessenger
    public init(editor: SKKInputEngine, messenger: SKKMessenger) {
        self.editor = editor
        self.messenger = messenger
    }

    public func bridgedDispatch(event: SKKStateMachineBrigdgedEvent) -> SKKStateMachineAction {
        return dispatch(event: event.value)
    }
    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.SetStateRegistration()
            messenger.Beep()
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
