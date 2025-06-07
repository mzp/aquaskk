//
//  SKKStateComposing.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/14.
//

// MARK: - level 1：構築

public class SKKStateComposing: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
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
            editor.handlePing()
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 2：見出し語編集

public class SKKStateEdit: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var context: SKKInputContext
    var config: SKKConfig
    var completer: SKKCompleterImpl
    var selector: SKKSelectorImpl
    init(editor: SKKInputEngineImpl, context: SKKInputContext, config: SKKConfig, completer: SKKCompleterImpl, selector: SKKSelectorImpl) {
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
            editor.commit()
            if config.SuppressNewlineOnCommit() {
                return .transitionKanaInput
            } else {
                return .forwardKanaInput
            }

        case .jmode:
            editor.commit()
            return .transitionKanaInput

        case .cancel:
            if context.undo.IsActive() {
                let candidate = context.undo.Candidate()
                context.output.Fix(candidate)
            }
            return .transitionKanaInput

        case .backspace:
            editor.handleBackSpace()
            if context.needs_setback {
                return .transitionKanaInput
            }
            return .handled

        case .delete_:
            editor.handleDelete()
            return .handled

        case .left:
            editor.handleCursorLeft()
            return .handled

        case .right:
            editor.handleCursorRight()
            return .handled

        case .up:
            editor.handleCursorUp()
            return .handled

        case .down:
            editor.handleCursorDown()
            return .handled

        case .charInput:
            let param = event.param
            if param.IsCompConversion() {
                completer.execute(limit: 1)
            }
            if param.IsNextCandidate() || param.IsCompConversion() {
                if context.entry.IsEmpty() {
                    return .transitionKanaInput
                }
                if selector.execute(inlineCount: Int(config.MaxCountOfInlineCandidates())) {
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

public class SKKStateEntryInput: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var completer: SKKCompleterImpl

    init(editor: SKKInputEngineImpl, completer: SKKCompleterImpl) {
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
            editor.setStateComposing()
            return .handled

        case .exitEvent:
            return .saveHistory

        case .tab:
            if completer.execute(limit: 0) {
                return .transitionEntryCompletion
            }
            return .handled

        default:
            return .super_
        }
    }
}

// MARK: - level 4 (sub of EntryInput)：日本語

public class SKKStateKanaEntry: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var context: SKKInputContext
    var config: SKKConfig
    init(editor: SKKInputEngineImpl, context: SKKInputContext, config: SKKConfig) {
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
            editor.setStateComposing()
            return .handled

        case .charInput:
            let param = event.param
            // 変換
            if param.IsNextCandidate() {
                return .super_
            }
            // トグル変換 #1
            if param.IsToggleKana() {
                editor.toggleKana()
                return .transitionKanaInput
            }

            // トグル変換 #2
            if param.IsToggleJisx0201Kana() {
                editor.toggleJisx0201Kana()
                return .transitionKanaInput
            }

            // Sticky key
            if param.IsStickyKey() {
                if context.entry.IsEmpty() {
                    if param.IsInputChars() {
                        editor.handleChar(code: Int(param.code), direct: param.IsDirect())
                    }
                    editor.commit()
                    return .transitionKanaInput
                } else {
                    return .transitionOkuriInput
                }
            }

            // 送りあり
            if param.IsUpperCases(), !context.entry.IsEmpty() {
                return .forwardOkuriInput
            }

            if !editor.canConvert(code: Int(param.code)) {
                if param.IsSwitchToAscii() {
                    editor.commit()
                    return .transitionAsciiMode
                }

                if param.IsSwitchToJisx0208Latin() {
                    editor.commit()
                    return .transitionJisx0208LatinMode
                }

                if param.IsEnterJapanese() {
                    if config.HandleRecursiveEntryAsOkuri(), !context.entry.IsEmpty() {
                        return .transitionOkuriInput
                    }
                    editor.commit()
                    return .forwardKanaInput
                }
            }
            if param.IsInputChars() {
                editor.handleChar(code: Int(param.code), direct: param.IsDirect())
                return .handled
            }
            fallthrough

        default:
            return .super_
        }
    }
}

// MARK: - level 4 (sub of EntryInput)：省略表記

public class SKKStateAsciiEntry: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var context: SKKInputContext
    init(editor: SKKInputEngineImpl, context: SKKInputContext) {
        self.editor = editor
        self.context = context
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.selectInputMode(inputMode: .AsciiInputMode)
            return .handled

        case .charInput:
            let param = event.param
            if param.IsNextCandidate() {
                return .super_
            }
            if param.IsToggleJisx0201Kana(), !context.entry.IsEmpty() {
                editor.toggleJisx0201Kana()
                return .transitionKanaInput
            }
            if param.IsInputChars() {
                editor.handleChar(code: Int(param.code), direct: param.IsDirect())
                return .handled
            }
            return .super_

        default:
            return .super_
        }
    }
}

// MARK: - level 3 (sub of Edit)：見出し語補完

public class SKKStateEntryCompletion: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var completer: SKKCompleterImpl
    var messenger: SKKMessengerProtocol
    init(editor: SKKInputEngineImpl, completer: SKKCompleterImpl, messenger: SKKMessengerProtocol) {
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
            editor.setStateComposing()
            return .handled

        case .tab:
            completer.next()
            return .handled

        case .charInput:
            let param = event.param
            if param.IsNextCompletion() {
                completer.next()
                return .handled
            }
            if param.IsPrevCompletion() {
                completer.prev()
                return .handled
            }
            if param.IsNextCandidate() {
                return .super_
            }
            if param.IsRemoveTrigger() {
                if completer.remove() {
                    messenger.send(message: "見出し語を削除しました")
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

public class SKKStateSelectCandidate: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var selector: SKKSelectorImpl
    var config: SKKConfig
    init(editor: SKKInputEngineImpl, config: SKKConfig, selector: SKKSelectorImpl) {
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
            editor.setStateSelectCandidate()
            selector.show()
            return .handled

        case .exitEvent:
            selector.hide()
            return .handled

        case .jmode:
            editor.commit()
            return .transitionKanaInput

        case .enter:
            editor.commit()
            if !config.SuppressNewlineOnCommit() {
                return .forwardKanaInput
            }
            return .transitionKanaInput

        case .cancel:
            return .deepHistoryEntryInput

        case .left:
            selector.cursorLeft()
            return .handled

        case .right:
            selector.cursorRight()
            return .handled

        case .up:
            selector.cursorUp()
            return .handled

        case .down:
            selector.cursorDown()
            return .handled

        case .backspace:
            if selector.isInline, config.InlineBackSpaceImpliesCommit() {
                editor.commit()
                return .forwardKanaInput
            }
            if selector.prev() {
                return .handled
            } else {
                return .deepHistoryEntryInput
            }

        case .charInput:
            let param = event.param
            if param.IsPrevCandidate() {
                if selector.prev() {
                    return .handled
                } else {
                    return .deepHistoryEntryInput
                }
            }

            if param.IsNextCandidate() {
                if selector.next() {
                    return .handled
                } else {
                    return .transitionRecursiveRegister
                }
            }
            if param.IsRemoveTrigger() {
                return .transitionEntryRemove
            }
            if param.IsInputChars() || param.IsToggleJisx0201Kana() {
                if selector.isInline {
                    editor.commit()
                    return .deepForwardKanaInput
                }
                if selector.select(label: Int(param.code)) {
                    editor.commit()
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

public class SKKStateOkuriInput: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: (any HandlerProtocol)? = nil
    var editor: SKKInputEngineImpl
    var config: SKKConfig
    var context: SKKInputContext
    var selector: SKKSelectorImpl
    init(editor: SKKInputEngineImpl, config: SKKConfig, context: SKKInputContext, selector: SKKSelectorImpl) {
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
            editor.setStateOkuri()
            return .handled

        case .enter:
            editor.commit()
            // 改行するかどうか？(egg-like-new-line)
            if !config.SuppressNewlineOnCommit() {
                return .forwardKanaInput
            }
            return .transitionKanaInput

        case .jmode:
            editor.commit()
            return .transitionKanaInput

        case .cancel:
            editor.reset()
            return .transitionKanaEntry

        case .delete_,
             .down,
             .left,
             .right,
             .tab,
             .up:
            return .handled

        case .backspace:
            editor.handleBackSpace()
            if context.needs_setback {
                return .transitionKanaEntry
            }
            return .handled

        case .charInput:
            let param = event.param
            if param.IsInputChars() {
                editor.handleChar(code: Int(param.code), direct: param.IsDirect())
            }
            if param.IsNextCandidate() || editor.isOkuriComplete {
                if selector.execute(inlineCount: Int(config.MaxCountOfInlineCandidates())) {
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
