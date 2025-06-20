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
    var context: SKKInputContextImpl
    var config: SKKConfigProtocol
    var completer: SKKCompleterImpl
    var selector: SKKSelectorImpl
    init(editor: SKKInputEngineImpl, context: SKKInputContextImpl, config: SKKConfigProtocol, completer: SKKCompleterImpl, selector: SKKSelectorImpl) {
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
            context.undo.clear()
            return .saveHistory

        case .enter:
            editor.commit()
            if config.suppressNewlineOnCommit() {
                return .transitionKanaInput
            } else {
                return .forwardKanaInput
            }

        case .jmode:
            editor.commit()
            return .transitionKanaInput

        case .cancel:
            if context.undo.isActive {
                let candidate = context.undo.candidate
                context.output.fix(string: candidate)
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
            if param.isCompConversion {
                completer.execute(limit: 1)
            }
            if param.isNextCandidate || param.isCompConversion {
                if context.entry.isEmpty {
                    return .transitionKanaInput
                }
                if selector.execute(inlineCount: config.maxCountOfInlineCandidates()) {
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
    var context: SKKInputContextImpl
    var config: SKKConfigProtocol
    init(editor: SKKInputEngineImpl, context: SKKInputContextImpl, config: SKKConfigProtocol) {
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
            if param.isNextCandidate {
                return .super_
            }
            // トグル変換 #1
            if param.isToggleKana {
                editor.toggleKana()
                return .transitionKanaInput
            }

            // トグル変換 #2
            if param.isToggleJisx0201Kana {
                editor.toggleJisx0201Kana()
                return .transitionKanaInput
            }

            // Sticky key
            if param.isStickyKey {
                if context.entry.isEmpty {
                    if param.isInputChars {
                        editor.handleChar(code: Int(param.code), direct: param.isDirect)
                    }
                    editor.commit()
                    return .transitionKanaInput
                } else {
                    return .transitionOkuriInput
                }
            }

            // 送りあり
            if param.isUpperCases, !context.entry.isEmpty {
                return .forwardOkuriInput
            }

            if !editor.canConvert(code: Int(param.code)) {
                if param.isSwitchToAscii {
                    editor.commit()
                    return .transitionAsciiMode
                }

                if param.isSwitchToJisx0208Latin {
                    editor.commit()
                    return .transitionJisx0208LatinMode
                }

                if param.isEnterJapanese {
                    if config.handleRecursiveEntryAsOkuri(), !context.entry.isEmpty {
                        return .transitionOkuriInput
                    }
                    editor.commit()
                    return .forwardKanaInput
                }
            }
            if param.isInputChars {
                editor.handleChar(code: Int(param.code), direct: param.isDirect)
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
    var context: SKKInputContextImpl
    init(editor: SKKInputEngineImpl, context: SKKInputContextImpl) {
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
            if param.isNextCandidate {
                return .super_
            }
            if param.isToggleJisx0201Kana, !context.entry.isEmpty {
                editor.toggleJisx0201Kana()
                return .transitionKanaInput
            }
            if param.isInputChars {
                editor.handleChar(code: Int(param.code), direct: param.isDirect)
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
            if param.isNextCompletion {
                completer.next()
                return .handled
            }
            if param.isPrevCompletion {
                completer.prev()
                return .handled
            }
            if param.isNextCandidate {
                return .super_
            }
            if param.isRemoveTrigger {
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
    var config: SKKConfigProtocol
    init(editor: SKKInputEngineImpl, config: SKKConfigProtocol, selector: SKKSelectorImpl) {
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
            if !config.suppressNewlineOnCommit() {
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
            if selector.isInline, config.inlineBackSpaceImpliesCommit() {
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
            if param.isPrevCandidate {
                if selector.prev() {
                    return .handled
                } else {
                    return .deepHistoryEntryInput
                }
            }

            if param.isNextCandidate {
                if selector.next() {
                    return .handled
                } else {
                    return .transitionRecursiveRegister
                }
            }
            if param.isRemoveTrigger {
                return .transitionEntryRemove
            }
            if param.isInputChars || param.isToggleJisx0201Kana {
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
    var config: SKKConfigProtocol
    var context: SKKInputContextImpl
    var selector: SKKSelectorImpl
    init(editor: SKKInputEngineImpl, config: SKKConfigProtocol, context: SKKInputContextImpl, selector: SKKSelectorImpl) {
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
            if !config.suppressNewlineOnCommit() {
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
            if param.isInputChars {
                editor.handleChar(code: Int(param.code), direct: param.isDirect)
            }
            if param.isNextCandidate || editor.isOkuriComplete {
                if selector.execute(inlineCount: config.maxCountOfInlineCandidates()) {
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
