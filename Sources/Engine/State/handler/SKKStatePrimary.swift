//
//  SKKStatePrimary.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/11.
//

public enum StateTransitionResult: Int {
    case topState
}

// MARK: - level 1：直接入力

public class SKKStatePrimary: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil

    var editor: SKKInputEngineImpl
    var context: SKKInputContext
    var messenger: SKKMessenger
    init(editor: SKKInputEngineImpl, context: SKKInputContext, messenger: SKKMessenger) {
        self.editor = editor
        self.context = context
        self.messenger = messenger
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .initEvent:
            return .initializeKanaInput

        case .entryEvent:
            editor.setStatePrimary()
            return .handled

        case .jmode:
            editor.commit()
            return .handled

        case .enter:
            editor.handleEnter()
            return .handled

        case .cancel:
            editor.handleCancel()
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
            editor.handlePaste()
            return .handled

        case .ping:
            editor.handlePing()
            return .handled

        case .backspace:
            editor.handleBackSpace()
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
                editor.reset()
                return .handled
            }
        }
        return .super_
    }
}

// MARK: - level 2 (sub of Primary)：かな入力

public class SKKStateKanaInput: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil

    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .initEvent:
            return .shallowHistoryHirakana

        case .exitEvent:
            return .saveHistory

        case .charInput:
            let param = event.param
            if !editor.canConvert(code: Int(param.code)) {
                if param.IsSwitchToAscii() {
                    return .transitionAsciiMode
                }

                if param.IsSwitchToJisx0208Latin() {
                    return .transitionJisx0208LatinMode
                }

                if param.IsEnterAbbrev() {
                    return .transitionAsciiEntry
                }

                if param.IsEnterJapanese() {
                    return .transitionKanaEntry
                }
            }
            if param.IsStickyKey() {
                return .transitionKanaEntry
            }
            if param.IsUpperCases() {
                return .forwardKanaEntry
            }

            // キー修飾がない場合のみローマ字かな変換を実施する
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

// MARK: - level 3 (sub of KanaInput)：ひらかな

public class SKKStateHirakana: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil

    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.selectInputMode(inputMode: .HirakanaInputMode)
            return .handled

        case .hirakanaMode:
            return .handled

        case .charInput:
            let param = event.param
            if !(param.IsInputChars() && editor.canConvert(code: Int(param.code))) {
                // 変換する文字がない場合のみ、ToggleKana等の処理する
                //
                // 例: AZIKの場合
                //
                //   - [: ToggeKana
                //   - x[: 鍵括弧
                //
                // が割り当てられている
                if param.IsToggleKana() {
                    return .transitionKatakanaMode
                }

                if param.IsToggleJisx0201Kana() {
                    return .transitionJisx0201KanaMode
                }
            }
            fallthrough

        default:
            return .super_
        }
    }
}

public class SKKStateKatakana: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
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
        case .entryEvent:
            editor.selectInputMode(inputMode: .KatakanaInputMode)
            return .handled

        case .katakanaMode:
            return .handled

        default:
            let param = event.param
            if !(event.id == .charInput && param.IsInputChars() && editor.canConvert(code: Int(param.code))) {
                // 変換する文字がない場合のみ、ToggleKana等の処理する
                if event.id == .jmode || event.param.IsToggleKana() {
                    return .transitionHirakanaMode
                }
                if param.IsToggleJisx0201Kana() {
                    return .transitionJisx0201KanaMode
                }
            }
            return .super_
        }
    }
}

// MARK: - level 3 (sub of KanaInput)：半角カタカナ

public class SKKStateJisx0201Kana: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil
    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.selectInputMode(inputMode: .Jisx0201KanaInputMode)
            return .handled

        case .jisx0201KanaMode:
            return .handled

        default:
            let param = event.param
            if !(event.id == .charInput && param.IsInputChars() && editor.canConvert(code: Int(param.code))) {
                // 変換する文字がない場合のみ、ToggleKana等の処理する
                if event.id == .jmode || event.param.IsToggleKana() || param.IsToggleJisx0201Kana() {
                    return .transitionHirakanaMode
                }
            }
            return .super_
        }
    }
    // case ENTRY_EVENT:
    //     editor_->SelectInputMode(SKKInputMode::Jisx0201KanaInputMode);
    //     return 0;
    //
    // case SKK_JISX0201KANA_MODE:
    //     return 0;
    //
    // default:
    //     if(!(event == SKK_CHAR && param.IsInputChars() && editor_->CanConvert(param.code))) {
    //         // 変換する文字がない場合のみ、ToggleKana等の処理する
    //         if(event == SKK_JMODE || param.IsToggleKana() || param.IsToggleJisx0201Kana()) {
    //             return State::Transition(&SKKState::Hirakana);
    //         }
    //     }
}

// MARK: - level 2 (sub of Primary)：Latin 入力

public class SKKStateLatinInput: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil
    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        let param = event.param
        switch event.id {
        case .jmode:
            return .transitionHirakanaMode

        case .charInput:
            if param.IsInputChars() {
                var code = param.code
                if (param.option & Int32(CapsLock)) != 0,
                   let uppercased = String(UnicodeScalar(code)).uppercased().first
                {
                    code = uppercased.asciiValue ?? code
                }
                editor.handleChar(code: Int(code), direct: param.IsDirect())
            }
            fallthrough

        default:
            return .super_
        }
    }
}

// ======================================================================

// MARK: - level 2 (sub of LatinInput)：ASCII

/// ======================================================================
public class SKKStateAscii: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil
    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.selectInputMode(inputMode: .AsciiInputMode)
            return .handled

        case .asciiMode:
            return .handled

        default:
            return .super_
        }
    }
}

/// ======================================================================
/// level 2 (sub of LatinInput)：全角英数
/// ======================================================================
public class SKKStateJisx0208Latin: HandlerProtocol {
    var handlerID: String { NSStringFromClass(Self.self) as String }
    var super_: HandlerProtocol? = nil
    var editor: SKKInputEngineImpl
    init(editor: SKKInputEngineImpl) {
        self.editor = editor
    }

    public func bridgedDispatch(event: SKKStateMachineEvent) -> Int32 {
        return dispatch(event: event).rawValue
    }

    public func dispatch(event: SKKStateMachineEvent) -> SKKStateMachineAction {
        switch event.id {
        case .entryEvent:
            editor.selectInputMode(inputMode: .Jisx0208LatinInputMode)
            return .handled

        case .jisx0208LatinMode:
            return .handled

        default:
            let param = event.param
            if event.id == .asciiMode || (!param.IsInputChars() && param.IsSwitchToAscii()) {
                return .transitionAsciiMode
            }
            return .super_
        }
    }
}
