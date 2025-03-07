/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008-2009 Tomotaka SUWA <t.suwa@mac.com>

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

#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputEngine.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKInputEngine::SKKInputEngine(SKKInputEnvironment *env)
    : impl_(new SwiftObject(AquaSKKEngine::SKKInputEngineImpl::init(
          env, AquaSKKEngine::SKKInputQueueImpl::init(this),
          AquaSKKEngine::SKKOkuriEditorImpl::init(env->InputContext(), this)))) {}

void SKKInputEngine::SelectInputMode(SKKInputMode mode) {
    (*impl_)->bridgedSelectInputMode(static_cast<int>(mode));
}

void SKKInputEngine::SetStatePrimary() {
    (*impl_)->setStatePrimary();
}

void SKKInputEngine::SetStateComposing() {
    (*impl_)->setStateComposing();
}

void SKKInputEngine::SetStateOkuri() {
    (*impl_)->setStateOkuri();
}

void SKKInputEngine::SetStateSelectCandidate() {
    (*impl_)->setStateSelectCandidate();
}

void SKKInputEngine::SetStateEntryRemove() {
    (*impl_)->setStateEntryRemove();
}

void SKKInputEngine::SetStateRegistration() {
    (*impl_)->setStateRegistration();
}

void SKKInputEngine::HandleChar(char code, bool direct) {
    (*impl_)->handleChar(code, direct);
}

void SKKInputEngine::HandleBackSpace() {
    (*impl_)->handleBackSpace();
}

void SKKInputEngine::HandleDelete() {
    (*impl_)->handleDelete();
}

void SKKInputEngine::HandleCursorLeft() {
    (*impl_)->handleCursorLeft();
}

void SKKInputEngine::HandleCursorRight() {
    (*impl_)->handleCursorRight();
}

void SKKInputEngine::HandleCursorUp() {
    (*impl_)->handleCursorUp();
}

void SKKInputEngine::HandleCursorDown() {
    (*impl_)->handleCursorDown();
}

void SKKInputEngine::HandlePaste() {
    (*impl_)->handlePaste();
}

void SKKInputEngine::HandlePing() {
    (*impl_)->handlePing();
}

void SKKInputEngine::HandleEnter() {
    (*impl_)->handleEnter();
}

void SKKInputEngine::HandleCancel() {
    (*impl_)->handleCancel();
}

void SKKInputEngine::Commit() {
    (*impl_)->commit();
}

void SKKInputEngine::Reset() {
    (*impl_)->reset();
}

void SKKInputEngine::ToggleKana() {
    (*impl_)->toggleKana();
}

void SKKInputEngine::ToggleJisx0201Kana() {
    (*impl_)->toggleJisx0201Kana();
}

void SKKInputEngine::UpdateInputContext() {
    (*impl_)->updateInputContext();
}

bool SKKInputEngine::CanConvert(char code) const {
    return (*impl_)->canConvert(code);
}

bool SKKInputEngine::IsOkuriComplete() const {
    return (*impl_)->isOkuriComplete();
}

// MARK: callback

void SKKInputEngine::SKKInputQueueUpdate(const SKKInputQueueObserverState &state) {
    (*impl_)->inputQueueUpdate(state);
}

const std::string SKKInputEngine::SKKCompleterQueryString() {
    return (*impl_)->completerQueryString();
}

void SKKInputEngine::SKKCompleterUpdate(const std::string &entry) {
    (*impl_)->completerUpdate(entry);
}

const SKKEntry SKKInputEngine::SKKSelectorQueryEntry() {
    auto array = (*impl_)->bridgeSelectorQueryEntry();
    return SKKEntry(array[0], array[1]);
}

void SKKInputEngine::SKKSelectorUpdate(const SKKCandidate &candidate) {
    (*impl_)->bridgeSelectorUpdate(candidate.ToString());
}

void SKKInputEngine::SKKOkuriListenerAppendEntry(const std::string &fixed) {
    (*impl_)->okkuriListenerAppendEntry(fixed);
}
