//
//  SKKStateComposing.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/14.
//

// MARK: - level 1：構築

public class SKKStateComposing {
    var editor: SKKInputEngine
    public init(editor: SKKInputEngine) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .exitEvent:
            return .saveHistory

        case .ping:
            editor.HandlePing()
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 2：見出し語編集

public class SKKStateEdit {
    var editor: SKKInputEngine
    var context: SKKInputContext
    var config: SKKConfig
    var completer: SKKCompleter
    var selector: SKKSelector
    public init(editor: SKKInputEngine, context: SKKInputContext, config: SKKConfig, completer: SKKCompleter, selector: SKKSelector) {
        self.editor = editor
        self.context = context
        self.config = config
        self.completer = completer
        self.selector = selector
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .exitEvent:
            context.undo.Clear()
            return .saveHistory

        case .enter:
            editor.Commit()
            if config.SuppressNewlineOnCommit() {
                return .transitionKanaInput
            } else {
                return .forwardKanaInput
            }

        case .jmode:
            editor.Commit()
            return .transitionKanaInput

        case .cancel:
            if context.undo.IsActive() {
                let candidate = context.undo.Candidate()
                context.output.Fix(candidate)
            }
            return .transitionKanaInput

        case .backspace:
            editor.HandleBackSpace()
            if context.needs_setback {
                return .transitionKanaInput
            }
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

        case .charInput:
            let param = event.param
            if param.IsCompConversion() {
                completer.Execute(1)
            }
            if param.IsNextCandidate() || param.IsCompConversion() {
                if context.entry.IsEmpty() {
                    return .transitionKanaInput
                }
                if selector.Execute(config.MaxCountOfInlineCandidates()) {
                    return .transitionSelectCandidate
                }
                return .transitionRecursiveRegister
            }
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 3 (sub of Edit)：見出し語入力

public class SKKStateEntryInput {
    var editor: SKKInputEngine
    var completer: SKKCompleter

    public init(editor: SKKInputEngine, completer: SKKCompleter) {
        self.editor = editor
        self.completer = completer
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        // 履歴を保存するだけ
        switch event.id {
        case .entryEvent:
            editor.SetStateComposing()
            return .handled

        case .exitEvent:
            return .saveHistory

        case .tab:
            if completer.Execute() {
                return .transitionEntryCompletion
            }
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 4 (sub of EntryInput)：日本語

public class SKKStateKanaEntry {
    var editor: SKKInputEngine
    var context: SKKInputContext
    var config: SKKConfig
    public init(editor: SKKInputEngine, context: SKKInputContext, config: SKKConfig) {
        self.editor = editor
        self.context = context
        self.config = config
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            // 再入用
            editor.SetStateComposing()
            return .handled

        case .charInput:
            let param = event.param
            // 変換
            if param.IsNextCandidate() {
                return .super_
            }
            // トグル変換 #1
            if param.IsToggleKana() {
                editor.ToggleKana()
                return .transitionKanaInput
            }

            // トグル変換 #2
            if param.IsToggleJisx0201Kana() {
                editor.ToggleJisx0201Kana()
                return .transitionKanaInput
            }

            // Sticky key
            if param.IsStickyKey() {
                if context.entry.IsEmpty() {
                    if param.IsInputChars() {
                        editor.HandleChar(CChar(param.code), param.IsDirect())
                    }
                    editor.Commit()
                    return .transitionKanaInput
                } else {
                    return .transitionOkuriInput
                }
            }

            // 送りあり
            if param.IsUpperCases(), !context.entry.IsEmpty() {
                return .forwardOkuriInput
            }

            if !editor.CanConvert(CChar(param.code)) {
                if param.IsSwitchToAscii() {
                    editor.Commit()
                    return .transitionAsciiMode
                }

                if param.IsSwitchToJisx0208Latin() {
                    editor.Commit()
                    return .transitionJisx0208LatinMode
                }

                if param.IsEnterJapanese() {
                    if config.HandleRecursiveEntryAsOkuri(), !context.entry.IsEmpty() {
                        return .transitionOkuriInput
                    }
                    editor.Commit()
                    return .forwardKanaInput
                }
            }
            if param.IsInputChars() {
                editor.HandleChar(CChar(param.code), param.IsDirect())
                return .handled
            }
            fallthrough

        default:
            return .super_
        }
    }
}

// MARK: - level 4 (sub of EntryInput)：省略表記

public class SKKStateAsciiEntry {
    var editor: SKKInputEngine
    var context: SKKInputContext
    public init(editor: SKKInputEngine, context: SKKInputContext) {
        self.editor = editor
        self.context = context
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.SelectInputMode(.AsciiInputMode)
            return .handled

        case .charInput:
            let param = event.param
            if param.IsNextCandidate() {
                return .super_
            }
            if param.IsToggleJisx0201Kana(), !context.entry.IsEmpty() {
                editor.ToggleJisx0201Kana()
                return .transitionKanaInput
            }
            if param.IsInputChars() {
                editor.HandleChar(CChar(param.code), param.IsDirect())
                return .handled
            }
            return .super_

        default:
            return .super_
        }
    }
}

// MARK: - level 3 (sub of Edit)：見出し語補完

public class SKKStateEntryCompletion {
    var editor: SKKInputEngine
    var completer: SKKCompleter
    var messenger: SKKMessenger
    public init(editor: SKKInputEngine, completer: SKKCompleter, messenger: SKKMessenger) {
        self.editor = editor
        self.completer = completer
        self.messenger = messenger
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.SetStateComposing()
            return .handled

        case .tab:
            completer.Next()
            return .handled

        case .charInput:
            let param = event.param
            if param.IsNextCompletion() {
                completer.Next()
                return .handled
            }
            if param.IsPrevCompletion() {
                completer.Prev()
                return .handled
            }
            if param.IsNextCandidate() {
                return .super_
            }
            if param.IsRemoveTrigger() {
                if completer.Remove() {
                    messenger.SendMessage("見出し語を削除しました")
                    return .transitionKanaInput
                } else {
                    return .handled
                }
            }
            fallthrough

        default:
            // システムイベント以外は履歴に転送する
            if !event.IsSystem() {
                return .deepForwardEntryInput
            }
            return .super_
        }
    }
}

// MARK: - level 2：候補選択

public class SKKStateSelectCandidate {
    var editor: SKKInputEngine
    var selector: SKKSelector
    var config: SKKConfig
    public init(editor: SKKInputEngine, config: SKKConfig, selector: SKKSelector) {
        self.editor = editor
        self.config = config
        self.selector = selector
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.SetStateSelectCandidate()
            selector.Show()
            return .handled

        case .exitEvent:
            selector.Hide()
            return .handled

        case .jmode:
            editor.Commit()
            return .transitionKanaInput

        case .enter:
            editor.Commit()
            if !config.SuppressNewlineOnCommit() {
                return .forwardKanaInput
            }
            return .transitionKanaInput

        case .cancel:
            return .deepHistoryEntryInput

        case .left:
            selector.CursorLeft()
            return .handled

        case .right:
            selector.CursorRight()
            return .handled

        case .up:
            selector.CursorUp()
            return .handled

        case .down:
            selector.CursorDown()
            return .handled

        case .backspace:
            if selector.IsInline(), config.InlineBackSpaceImpliesCommit() {
                editor.Commit()
                return .forwardKanaInput
            }
            if selector.Prev() {
                return .handled
            } else {
                return .deepHistoryEntryInput
            }

        case .charInput:
            let param = event.param
            if param.IsPrevCandidate() {
                if selector.Prev() {
                    return .handled
                } else {
                    return .deepHistoryEntryInput
                }
            }

            if param.IsNextCandidate() {
                if selector.Next() {
                    return .handled
                } else {
                    return .transitionRecursiveRegister
                }
            }
            if param.IsRemoveTrigger() {
                return .transitionEntryRemove
            }
            if param.IsInputChars() || param.IsToggleJisx0201Kana() {
                if selector.IsInline() {
                    editor.Commit()
                    return .deepForwardKanaInput
                }
                if selector.Select(CChar(param.code)) {
                    editor.Commit()
                    return .transitionKanaInput
                }
            }
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 1：送り

public class SKKStateOkuriInput {
    var editor: SKKInputEngine
    var config: SKKConfig
    var context: SKKInputContext
    var selector: SKKSelector
    public init(editor: SKKInputEngine, config: SKKConfig, context: SKKInputContext, selector: SKKSelector) {
        self.editor = editor
        self.config = config
        self.context = context
        self.selector = selector
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.SetStateOkuri()
            return .handled

        case .enter:
            editor.Commit()
            // 改行するかどうか？(egg-like-new-line)
            if !config.SuppressNewlineOnCommit() {
                return .forwardKanaInput
            }
            return .transitionKanaInput

        case .jmode:
            editor.Commit()
            return .transitionKanaInput

        case .cancel:
            editor.Reset()
            return .transitionKanaEntry

        case .delete_,
             .down,
             .left,
             .right,
             .tab,
             .up:
            return .handled

        case .backspace:
            editor.HandleBackSpace()
            if context.needs_setback {
                return .transitionKanaEntry
            }
            return .handled

        case .charInput:
            let param = event.param
            if param.IsInputChars() {
                editor.HandleChar(CChar(param.code), param.IsDirect())
            }
            if param.IsNextCandidate() || editor.IsOkuriComplete() {
                if selector.Execute(config.MaxCountOfInlineCandidates()) {
                    return .transitionSelectCandidate
                } else {
                    return .transitionRecursiveRegister
                }
            }

            return .handled

        default:
            return .super_
        }
    }
}
