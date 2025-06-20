//
//  SKKStateMachine.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/09.
//

import AquaSKKLogging
import OSLog

public class SKKStateMachineImpl {
    let primaryState: SKKStatePrimary
    let kanaInputState: SKKStateKanaInput
    let hirakanaInputState: SKKStateHirakana
    let katakanaInputState: SKKStateKatakana
    let jis0201kanaState: SKKStateJisx0201Kana
    let latinInputState: SKKStateLatinInput
    let asciiStateState: SKKStateAscii
    let jis0208LatinState: SKKStateJisx0208Latin
    let composingState: SKKStateComposing
    let editState: SKKStateEdit
    let entryInputState: SKKStateEntryInput
    let kanaEntryState: SKKStateKanaEntry
    let asciiEntryState: SKKStateAsciiEntry
    let entryCompletionState: SKKStateEntryCompletion
    let selectCandidateState: SKKStateSelectCandidate
    let okuriInputState: SKKStateOkuriInput
    let recursiveRegisterState: SKKStateRecursiveRegister
    let entryRemoveState: SKKStateEntryRemove

    var machine: GenericStateMachine?

    init(engine: SKKInputEngineImpl, context: SKKInputContextImpl, config: SKKConfigProtocol, completer: SKKCompleterImpl, selector: SKKSelectorImpl, messenger: SKKMessengerProtocol) {
        primaryState = .init(editor: engine, context: context, messenger: messenger)
        kanaInputState = .init(editor: engine)

        hirakanaInputState = .init(editor: engine)
        katakanaInputState = .init(editor: engine)
        kanaInputState.super_ = primaryState
        hirakanaInputState.super_ = kanaInputState
        katakanaInputState.super_ = kanaInputState
        jis0201kanaState = .init(editor: engine)
        jis0201kanaState.super_ = kanaInputState
        latinInputState = .init(editor: engine)
        latinInputState.super_ = primaryState
        asciiStateState = .init(editor: engine)
        asciiStateState.super_ = latinInputState
        jis0208LatinState = .init(editor: engine)
        jis0208LatinState.super_ = latinInputState

        composingState = .init(editor: engine)
        editState = .init(editor: engine, context: context, config: config, completer: completer, selector: selector)
        editState.super_ = composingState
        entryInputState = .init(editor: engine, completer: completer)
        entryInputState.super_ = editState

        kanaEntryState = .init(editor: engine, context: context, config: config)
        kanaEntryState.super_ = entryInputState
        asciiEntryState = .init(editor: engine, context: context)
        asciiEntryState.super_ = entryInputState

        entryCompletionState = .init(editor: engine, completer: completer, messenger: messenger)
        entryCompletionState.super_ = editState

        selectCandidateState = .init(editor: engine, config: config, selector: selector)
        selectCandidateState.super_ = composingState
        okuriInputState = .init(editor: engine, config: config, context: context, selector: selector)
        recursiveRegisterState = .init(editor: engine, messenger: messenger)
        entryRemoveState = .init(editor: engine, context: context, messenger: messenger)

        machine = GenericStateMachine(top: SKKStateTop(), inspector: DebugInspector(), bridgePerform: bridgePerform)
    }

    func bridgePerform(action: SKKStateMachineAction, super_: GenericState) -> GenericState? {
        switch action {
        case .initializePrimary:
            return .initial(handler: primaryState)
        case .initializeKanaInput:
            return .initial(handler: kanaInputState)
        case .transitionAsciiMode:
            return .transition(handler: asciiStateState)
        case .transitionHirakanaMode:
            return .transition(handler: hirakanaInputState)
        case .transitionKatakanaMode:
            return .transition(handler: katakanaInputState)
        case .transitionJisx0201KanaMode:
            return .transition(handler: jis0201kanaState)
        case .transitionJisx0208LatinMode:
            return .transition(handler: jis0208LatinState)
        case .transitionKanaEntry:
            return .transition(handler: kanaEntryState)
        case .transitionKanaInput:
            return .transition(handler: kanaInputState)
        case .transitionSelectCandidate:
            return .transition(handler: selectCandidateState)
        case .transitionRecursiveRegister:
            return .transition(handler: recursiveRegisterState)
        case .transitionEntryCompletion:
            return .transition(handler: entryCompletionState)
        case .transitionOkuriInput:
            return .transition(handler: okuriInputState)
        case .transitionEntryRemove:
            return .transition(handler: entryRemoveState)
        case .transitionAsciiEntry:
            return .transition(handler: asciiEntryState)
        case .forwardKanaInput:
            return .forward(handler: kanaInputState)
        case .forwardKanaEntry:
            return .forward(handler: kanaEntryState)
        case .forwardEntryInput:
            return .forward(handler: entryInputState)
        case .forwardOkuriInput:
            return .forward(handler: okuriInputState)
        case .shallowHistoryHirakana:
            return .shalllowHistory(handler: hirakanaInputState)
        case .saveHistory:
            return .saveHistory()
        case .deepForwardEntryInput:
            return .deepForward(handler: entryInputState)
        case .deepForwardKanaInput:
            return .deepForward(handler: kanaInputState)
        case .deepHistoryEntryInput:
            return .deepHistory(handler: entryInputState)
        case .deepHistoryComposing:
            return .deepHistory(handler: composingState)
        case .super_:
            return super_
        case .handled:
            return nil
        @unknown default:
            fatalError()
        }
    }

    public func dispatch(event: SKKEvent) {
        let genericEvent: GenericEvent = .init(signal: SKKEventID(rawValue: event.id) ?? SKKEventID.null, event: event)
        machine?.dispatch(event: genericEvent)
    }
}

struct DebugInspector: InspectorProtocol {
    func inspect(handler: any HandlerProtocol, event: GenericEvent) {
        let eventDump = event.event?.dump() ?? "<no event>"
        Logger.skkState.debug("[\(#fileID, privacy: .public):\(#function, privacy: .public)] \(handler.handlerID, privacy: .private) \(event.signal, privacy: .private) \(eventDump, privacy: .private)")
    }
}
