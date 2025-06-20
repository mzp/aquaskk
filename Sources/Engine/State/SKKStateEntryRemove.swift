//
//  SKKStateEntryRemove.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/14.
//

/// level 1：単語削除
public class SKKStateEntryRemove: HandlerProtocol {
    var super_: (any HandlerProtocol)? = nil

    var handlerID: String { NSStringFromClass(Self.self) as String }

    var editor: SKKInputEngineImpl
    var context: SKKInputContextImpl
    var messenger: SKKMessengerProtocol
    init(editor: SKKInputEngineImpl, context: SKKInputContextImpl, messenger: SKKMessengerProtocol) {
        self.editor = editor
        self.context = context
        self.messenger = messenger
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.setStateEntryRemove()
            return .handled

        case .enter:
            editor.commit()
            if !context.needs_setback {
                messenger.send(message: "単語を削除しました")
                return .transitionKanaInput
            }
            return .transitionSelectCandidate

        case .cancel:
            return .transitionSelectCandidate

        case .charInput:
            let param = event.param
            if param.isInputChars {
                // 入力文字は ASCII で受け付ける(常に非変換)
                editor.handleChar(code: Int(param.code), direct: true)
                return .handled
            }
            return .super_

        default:
            return .super_
        }
    }
}
