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

    var editor: SKKInputEngine
    var context: SKKInputContext
    var messenger: SKKMessenger
    public init(editor: SKKInputEngine, context: SKKInputContext, messenger: SKKMessenger) {
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
            editor.SetStateEntryRemove()
            return .handled

        case .enter:
            editor.Commit()
            if !context.needs_setback {
                messenger.SendMessage("単語を削除しました")
                return .transitionKanaInput
            }
            return .transitionSelectCandidate

        case .cancel:
            return .transitionSelectCandidate

        case .charInput:
            let param = event.param
            if param.IsInputChars() {
                // 入力文字は ASCII で受け付ける(常に非変換)
                editor.HandleChar(CChar(param.code), true)
                return .handled
            }
            return .super_

        default:
            return .super_
        }
    }
}
