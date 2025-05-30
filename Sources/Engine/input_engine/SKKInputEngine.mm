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

#import <AquaSKKBackend/SwiftObject.h>
#import <AquaSKKEngine/SKKInputContext.h>
#import <AquaSKKEngine/SKKInputEngine.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

struct SKKInputEngineContainer {
    SwiftObject<AquaSKKEngine::SKKInputEngineImpl> *impl_;

    SKKInputEngineContainer(SKKInputEnvironment *env, SKKInputEngine *engine)
        : impl_(new SwiftObject(
              AquaSKKEngine::SKKInputEngineImpl::init(
                  env, AquaSKKEngine::SKKInputQueueImpl::init(engine),
                  AquaSKKEngine::SKKOkuriEditorImpl::init(env->InputContext(), engine->getOkuriListenerProtocol())))) {}
};

SKKInputEngine::SKKInputEngine(SKKInputEnvironment *env)
    : container_(new SKKInputEngineContainer(env, this)) {}

void SKKInputEngine::SelectInputMode(SKKInputMode mode) {
    (*(container_->impl_))->bridgedSelectInputMode(static_cast<int>(mode));
}

void SKKInputEngine::SetStatePrimary() {
    (*(container_->impl_))->setStatePrimary();
}

void SKKInputEngine::SetStateComposing() {
    (*(container_->impl_))->setStateComposing();
}

void SKKInputEngine::SetStateOkuri() {
    (*(container_->impl_))->setStateOkuri();
}

void SKKInputEngine::SetStateSelectCandidate() {
    (*(container_->impl_))->setStateSelectCandidate();
}

void SKKInputEngine::SetStateEntryRemove() {
    (*(container_->impl_))->setStateEntryRemove();
}

void SKKInputEngine::SetStateRegistration() {
    (*(container_->impl_))->setStateRegistration();
}

void SKKInputEngine::HandleChar(char code, bool direct) {
    (*(container_->impl_))->handleChar(code, direct);
}

void SKKInputEngine::HandleBackSpace() {
    (*(container_->impl_))->handleBackSpace();
}

void SKKInputEngine::HandleDelete() {
    (*(container_->impl_))->handleDelete();
}

void SKKInputEngine::HandleCursorLeft() {
    (*(container_->impl_))->handleCursorLeft();
}

void SKKInputEngine::HandleCursorRight() {
    (*(container_->impl_))->handleCursorRight();
}

void SKKInputEngine::HandleCursorUp() {
    (*(container_->impl_))->handleCursorUp();
}

void SKKInputEngine::HandleCursorDown() {
    (*(container_->impl_))->handleCursorDown();
}

void SKKInputEngine::HandlePaste() {
    (*(container_->impl_))->handlePaste();
}

void SKKInputEngine::HandlePing() {
    (*(container_->impl_))->handlePing();
}

void SKKInputEngine::HandleEnter() {
    (*(container_->impl_))->handleEnter();
}

void SKKInputEngine::HandleCancel() {
    (*(container_->impl_))->handleCancel();
}

void SKKInputEngine::Commit() {
    (*(container_->impl_))->commit();
}

void SKKInputEngine::Reset() {
    (*(container_->impl_))->reset();
}

void SKKInputEngine::ToggleKana() {
    (*(container_->impl_))->toggleKana();
}

void SKKInputEngine::ToggleJisx0201Kana() {
    (*(container_->impl_))->toggleJisx0201Kana();
}

void SKKInputEngine::UpdateInputContext() {
    (*(container_->impl_))->updateInputContext();
}

bool SKKInputEngine::CanConvert(char code) const {
    return (*(container_->impl_))->canConvert(code);
}

bool SKKInputEngine::IsOkuriComplete() const {
    return (*(container_->impl_))->isOkuriComplete();
}

// MARK: callback

void SKKInputEngine::SKKInputQueueUpdate(const SKKInputQueueObserverState &state) {
    (*(container_->impl_))->inputQueueUpdate(state);
}

const std::string SKKInputEngine::SKKCompleterQueryString() {
    return (*(container_->impl_))->completerQueryString();
}

void SKKInputEngine::SKKCompleterUpdate(const std::string &entry) {
    (*(container_->impl_))->completerUpdate(entry);
}

const SKKEntry SKKInputEngine::SKKSelectorQueryEntry() {
    auto array = (*(container_->impl_))->bridgeSelectorQueryEntry();
    return SKKEntry(array[0], array[1]);
}

void SKKInputEngine::SKKSelectorUpdate(const SKKCandidate &candidate) {
    (*(container_->impl_))->bridgeSelectorUpdate(candidate.ToString());
}

void SKKInputEngine::SKKOkuriListenerAppendEntry(const std::string &fixed) {
    (*(container_->impl_))->okkuriListenerAppendEntry(fixed);
}

id<SKKCompleterBuddyProtcol> SKKInputEngine::getCompleterBuddyProtocol() {
    return (*(container_->impl_))->getCompleterBuddyProtocol();
}

id<SKKSelectorBuddyProtocol> SKKInputEngine::getSelectorBuddyProtocol() {
    return (*(container_->impl_))->getSelectorBuddyProtocol();
}

id<SKKOkuriListenerProtocol> SKKInputEngine::getOkuriListenerProtocol() {
    return (*(container_->impl_))->getOkuriListenerProtocol();
}
void retainSKKInputEngine(SKKInputEngine *obj) {
    obj->IntrusiveRefCounted<SKKInputEngine>::retain();
}

void releaseSKKInputEngine(SKKInputEngine *obj) {
    obj->IntrusiveRefCounted<SKKInputEngine>::release();
}
