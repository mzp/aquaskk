//
//  SKKStateMachineAction.swift
//  AquaSKKEngine
//
//  Created by mzp on 2025/06/12.
//

public enum SKKStateMachineAction: Int32 {
    case handled

    case initializePrimary
    case initializeKanaInput

    case transitionAsciiMode
    case transitionHirakanaMode
    case transitionKatakanaMode
    case transitionJisx0201KanaMode
    case transitionJisx0208LatinMode
    case transitionKanaEntry
    case transitionAsciiEntry
    case transitionKanaInput
    case transitionSelectCandidate
    case transitionRecursiveRegister
    case transitionEntryCompletion
    case transitionOkuriInput
    case transitionEntryRemove

    case forwardKanaInput
    case forwardKanaEntry
    case forwardEntryInput
    case forwardOkuriInput

    case shallowHistoryHirakana
    case saveHistory

    case deepForwardEntryInput
    case deepForwardKanaInput

    case deepHistoryEntryInput
    case deepHistoryComposing

    case super_
}
