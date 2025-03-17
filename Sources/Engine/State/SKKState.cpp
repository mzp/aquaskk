/* -*- C++ -*-

   MacOS X implementation of the SKK input method.

   Copyright (C) 2008 Tomotaka SUWA <t.suwa@mac.com>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

#include <cctype>
#import <AquaSKKBackend/SwiftObject.h>
#import <AquaSKKEngine/SKKConfig.h>
#import <AquaSKKEngine/SKKInputEngine.h>
#import <AquaSKKEngine/SKKMessenger.h>
#import <AquaSKKEngine/SKKState.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

namespace {
    typedef SKKState::Event Event;
    typedef SKKState::State State;
} // namespace

struct SKKStateContainer {
    // Primary
    SwiftObject<AquaSKKEngine::SKKStatePrimary> *primaryState;
    SwiftObject<AquaSKKEngine::SKKStateKanaInput> *kanaInputState;
    SwiftObject<AquaSKKEngine::SKKStateHirakana> *hirakanaState;
    SwiftObject<AquaSKKEngine::SKKStateKatakana> *katakanaState;
    SwiftObject<AquaSKKEngine::SKKStateJisx0201Kana> *jisx0201kanaState;
    SwiftObject<AquaSKKEngine::SKKStateLatinInput> *latinInputState;
    SwiftObject<AquaSKKEngine::SKKStateAscii> *asciiState;
    SwiftObject<AquaSKKEngine::SKKStateJisx0208Latin> *jis0208LatinState;

    // Composing
    SwiftObject<AquaSKKEngine::SKKStateComposing> *composingState;
    SwiftObject<AquaSKKEngine::SKKStateEdit> *editState;
    SwiftObject<AquaSKKEngine::SKKStateEntryInput> *entryInputState;
    SwiftObject<AquaSKKEngine::SKKStateKanaEntry> *kanaEntryState;
    SwiftObject<AquaSKKEngine::SKKStateAsciiEntry> *asciiEntryState;
    SwiftObject<AquaSKKEngine::SKKStateEntryCompletion> *entryCompletionState;
    SwiftObject<AquaSKKEngine::SKKStateSelectCandidate> *selectCandidateState;
    SwiftObject<AquaSKKEngine::SKKStateOkuriInput> *okuriInputState;

    SwiftObject<AquaSKKEngine::SKKStateEntryRemove> *entryRemoveState;
    SwiftObject<AquaSKKEngine::SKKStateRecursiveRegister> *recursiveRegisterState;

    SKKStateContainer(
        SKKConfig *config, SKKInputEngine *editor, SKKInputContext *context, SKKCompleter *completer,
        SKKSelector *selector, SKKMessenger *messenger)
        : primaryState(new SwiftObject(AquaSKKEngine::SKKStatePrimary::init(editor, context, messenger))),
          kanaInputState(new SwiftObject(AquaSKKEngine::SKKStateKanaInput::init(editor))),
          hirakanaState(new SwiftObject(AquaSKKEngine::SKKStateHirakana::init(editor))),
          katakanaState(new SwiftObject(AquaSKKEngine::SKKStateKatakana::init(editor))),
          jisx0201kanaState(new SwiftObject(AquaSKKEngine::SKKStateJisx0201Kana::init(editor))),
          latinInputState(new SwiftObject(AquaSKKEngine::SKKStateLatinInput::init(editor))),
          asciiState(new SwiftObject(AquaSKKEngine::SKKStateAscii::init(editor))),
          jis0208LatinState(new SwiftObject(AquaSKKEngine::SKKStateJisx0208Latin::init(editor))),
          composingState(new SwiftObject(AquaSKKEngine::SKKStateComposing::init(editor))),
          editState(new SwiftObject(AquaSKKEngine::SKKStateEdit::init(editor, context, config, completer, selector))),
          entryInputState(new SwiftObject(AquaSKKEngine::SKKStateEntryInput::init(editor, completer))),
          kanaEntryState(new SwiftObject(AquaSKKEngine::SKKStateKanaEntry::init(editor, context, config))),
          asciiEntryState(new SwiftObject(AquaSKKEngine::SKKStateAsciiEntry::init(editor, context))),
          entryCompletionState(
              new SwiftObject(AquaSKKEngine::SKKStateEntryCompletion::init(editor, completer, messenger))),
          selectCandidateState(new SwiftObject(AquaSKKEngine::SKKStateSelectCandidate::init(editor, config, selector))),
          okuriInputState(new SwiftObject(AquaSKKEngine::SKKStateOkuriInput::init(editor, config, context, selector))),
          entryRemoveState(new SwiftObject(AquaSKKEngine::SKKStateEntryRemove::init(editor, context, messenger))),
          recursiveRegisterState(new SwiftObject(AquaSKKEngine::SKKStateRecursiveRegister::init(editor, messenger))) {}
};

SKKState::SKKState(SKKInputEnvironment *env, SKKInputEngine *editor)
    : context_(env->InputContext()),
      messenger_(env->InputSessionParameter()->Messenger()),
      window_(env->InputSessionParameter()->CandidateWindow()),
      configuration_(env->InputSessionParameter()->Config()),
      editor_(editor),
      completer_(editor_),
      selector_(editor_, window_),
      container_(new SKKStateContainer(configuration_, editor_, context_, &completer_, &selector_, messenger_)) {}

SKKState::SKKState(const SKKState &src)
    : context_(src.context_),
      messenger_(src.messenger_),
      window_(src.window_),
      configuration_(src.configuration_),
      editor_(src.editor_),
      completer_(editor_),
      selector_(editor_, window_),
      container_(new SKKStateContainer(configuration_, editor_, context_, &completer_, &selector_, messenger_)) {}

void SKKState::ToString(const Handler handler, const Event &event, std::string &result) {
    static const char *systemEvent[] = {"PROBE", "<<ENTRY>>", "<<INIT>>", "<<EXIT>>"};

    static struct {
        Handler handler;
        const char *name;
    } states[] = {
#define DEFINE_State(arg) {&SKKState::arg, "SKKState::" #arg}
        DEFINE_State(Primary),
        DEFINE_State(KanaInput),
        DEFINE_State(Hirakana),
        DEFINE_State(Katakana),
        DEFINE_State(Jisx0201Kana),
        DEFINE_State(LatinInput),
        DEFINE_State(Ascii),
        DEFINE_State(Jisx0208Latin),
        DEFINE_State(Composing),
        DEFINE_State(Edit),
        DEFINE_State(EntryInput),
        DEFINE_State(KanaEntry),
        DEFINE_State(OkuriInput),
        DEFINE_State(AsciiEntry),
        DEFINE_State(EntryCompletion),
        DEFINE_State(SelectCandidate),
        DEFINE_State(EntryRemove),
        DEFINE_State(RecursiveRegister),
#undef DEFINE_State
        { 0, 0x00}
    };

    result.clear();

    for(int i = 0; states[i].handler != 0; ++i) {
        if(handler == states[i].handler) {
            result += states[i].name;
            result += ", ";
            if(event.IsSystem()) {
                result += systemEvent[abs(event)];
            } else {
                result += event.Param().dump();
            }
            return;
        }
    }
}

State SKKState::bridgePerform(SKKStateMachineAction action, State super_) {
    switch(action) {
    case SKKStateMachineAction::initializeKanaInput:
        return State::Initial(&SKKState::KanaInput);

    case SKKStateMachineAction::transitionAsciiEntry:
        return State::Transition(&SKKState::AsciiEntry);
    case SKKStateMachineAction::transitionKanaEntry:
        return State::Transition(&SKKState::KanaEntry);
    case SKKStateMachineAction::transitionAsciiMode:
        return State::Transition(&SKKState::Ascii);
    case SKKStateMachineAction::transitionHirakanaMode:
        return State::Transition(&SKKState::Hirakana);
    case SKKStateMachineAction::transitionKatakanaMode:
        return State::Transition(&SKKState::Katakana);
    case SKKStateMachineAction::transitionJisx0201KanaMode:
        return State::Transition(&SKKState::Jisx0201Kana);
    case SKKStateMachineAction::transitionJisx0208LatinMode:
        return State::Transition(&SKKState::Jisx0208Latin);
    case SKKStateMachineAction::transitionKanaInput:
        return State::Transition(&SKKState::KanaInput);
    case SKKStateMachineAction::transitionSelectCandidate:
        return State::Transition(&SKKState::SelectCandidate);
    case SKKStateMachineAction::transitionRecursiveRegister:
        return State::Transition(&SKKState::RecursiveRegister);
    case SKKStateMachineAction::transitionEntryCompletion:
        return State::Transition(&SKKState::EntryCompletion);
    case SKKStateMachineAction::transitionOkuriInput:
        return State::Transition(&SKKState::OkuriInput);
    case SKKStateMachineAction::transitionEntryRemove:
        return State::Transition(&SKKState::EntryRemove);

    case SKKStateMachineAction::forwardKanaInput:
        return State::Forward(&SKKState::KanaInput);
    case SKKStateMachineAction::forwardKanaEntry:
        return State::Forward(&SKKState::KanaEntry);
    case SKKStateMachineAction::forwardEntryInput:
        return State::Forward(&SKKState::EntryInput);
    case SKKStateMachineAction::forwardOkuriInput:
        return State::Forward(&SKKState::OkuriInput);

    case SKKStateMachineAction::shallowHistoryHirakana:
        return State::ShallowHistory(&SKKState::Hirakana);
    case SKKStateMachineAction::saveHistory:
        return State::SaveHistory();

    case SKKStateMachineAction::deepForwardEntryInput:
        return State::DeepForward(&SKKState::EntryInput);
    case SKKStateMachineAction::deepForwardKanaInput:
        return State::DeepForward(&SKKState::KanaInput);

    case SKKStateMachineAction::deepHistoryEntryInput:
        return State::DeepHistory(&SKKState::EntryInput);
    case SKKStateMachineAction::deepHistoryComposing:
        return State::DeepHistory(&SKKState::Composing);

    case SKKStateMachineAction::handled:
        return 0;
    case SKKStateMachineAction::super_:
        return super_;
    }
}

#include "SKKStateComposing-inl.h"
#include "SKKStateEntryRemove-inl.h"
#include "SKKStatePrimary-inl.h"
#include "SKKStateRecursiveRegister-inl.h"
