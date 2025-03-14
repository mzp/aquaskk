//
//  SKKStatePrimary.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/11.
//

import Foundation

public enum StateTransitionResult: Int {
    case topState
}

/// level 1：直接入力
public class SKKStatePrimary {
    var editor: SKKInputEngine
    var context: SKKInputContext
    var messenger: SKKMessenger
    public init(editor: SKKInputEngine, context: SKKInputContext, messenger: SKKMessenger) {
        self.editor = editor
        self.context = context
        self.messenger = messenger
    }

    public func hello() {}
    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .initEvent:
            return .initializeKanaInput

        case .entryEvent:
            editor.SetStatePrimary()
            return .handled

        case .jmode:
            editor.Commit()
            return .handled

        case .enter:
            editor.HandleEnter()
            return .handled

        case .cancel:
            editor.HandleCancel()
            return .handled

        case .undo:
            // Undo 可能なら見出し語入力に遷移する
            switch context.undo.Undo() {
            case .UndoKanaEntry:
                return .transitionKanaEntry
            case .UndoAsciiEntry:
                return .transitionAsciiEntry
            default:
                messenger.SendMessage("Undo できませんでした")
                context.event_handled = true
                return .handled
            }

        case .paste:
            editor.HandlePaste()
            return .handled

        case .ping:
            editor.HandlePing()
            return .handled

        case .backspace:
            editor.HandleBackSpace()
            return .handled

        case .delete_:
            editor.HandleDelete()
            return .handled

        case .left:
            editor.HandleCursorLeft()
            return .handled

        case .right:
            editor.HandleCursorRight()
            return .handled

        case .up:
            editor.HandleCursorUp()
            return .handled

        case .down:
            editor.HandleCursorDown()
            return .handled

        case .asciiMode:
            return .transitionAsciiMode

        case .hirakanaMode:
            return .transitionHirakanaMode

        case .katakanaMode:
            return .transitionKatakanaMode

        case .jisx0201KanaMode:
            return .transitionJisx0201KanaMode

        case .jisx0208LatinMode:
            return .transitionJisx0208LatinMode

        default:
            // editor で処理されなかったイベントは全て「未処理」にする
            // SKK_TAB もここに来るため、SKK_CHAR でテストはできない
            if event.IsUser() {
                editor.Reset()
                return .handled
            }
        }
        return .delegateTopState
    }
}
