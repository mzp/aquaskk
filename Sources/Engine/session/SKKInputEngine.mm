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

SKKInputEngine::SKKInputEngine(SKKInputEnvironment *env) {
    impl_ = [[SKKInputEngineImpl alloc] initWithEnv:env];
}

void SKKInputEngine::SelectInputMode(SKKInputMode mode) {
    [impl_ bridgedSelectInputMode:static_cast<int>(mode)];
}

void SKKInputEngine::SetStatePrimary() {
    [impl_ setStatePrimary];
}

void SKKInputEngine::SetStateComposing() {
    [impl_ setStateComposing];
}

void SKKInputEngine::SetStateOkuri() {
    [impl_ setStateOkuri];
}

void SKKInputEngine::SetStateSelectCandidate() {
    [impl_ setStateSelectCandidate];
}

void SKKInputEngine::SetStateEntryRemove() {
    [impl_ setStateEntryRemove];
}

void SKKInputEngine::SetStateRegistration() {
    [impl_ setStateRegistration];
}

void SKKInputEngine::HandleChar(char code, bool direct) {
    [impl_ handleCharWithCode:code direct:direct];
}

void SKKInputEngine::HandleBackSpace() {
    [impl_ handleBackSpace];
}

void SKKInputEngine::HandleDelete() {
    [impl_ handleDelete];
}

void SKKInputEngine::HandleCursorLeft() {
    [impl_ handleCursorLeft];
}

void SKKInputEngine::HandleCursorRight() {
    [impl_ handleCursorRight];
}

void SKKInputEngine::HandleCursorUp() {
    [impl_ handleCursorUp];
}

void SKKInputEngine::HandleCursorDown() {
    [impl_ handleCursorDown];
}

void SKKInputEngine::HandlePaste() {
    [impl_ handlePaste];
}

void SKKInputEngine::HandlePing() {
    [impl_ handlePing];
}

void SKKInputEngine::HandleEnter() {
    [impl_ handleEnter];
}

void SKKInputEngine::HandleCancel() {
    [impl_ handleCancel];
}

void SKKInputEngine::Commit() {
    [impl_ commit];
}

void SKKInputEngine::Reset() {
    [impl_ reset];
}

void SKKInputEngine::ToggleKana() {
    [impl_ toggleKana];
}

void SKKInputEngine::ToggleJisx0201Kana() {
    [impl_ toggleJisx0201Kana];
}

void SKKInputEngine::UpdateInputContext() {
    [impl_ updateInputContext];
}

bool SKKInputEngine::CanConvert(char code) const {
    return [impl_ canConvertWithCode:code];
}

bool SKKInputEngine::IsOkuriComplete() const {
    return [impl_ isOkuriComplete];
}

// MARK: callback

void SKKInputEngine::SKKInputQueueUpdate(const SKKInputQueueObserverState &state) {
    [impl_ bridgeInputQueueUpdateWithFixed:[NSString stringWithUTF8String:state.fixed.c_str()]
                              intermediate:[NSString stringWithUTF8String:state.intermediate.c_str()]
                                     queue:[NSString stringWithUTF8String:state.queue.c_str()]
                                      code:state.code];
}

const std::string SKKInputEngine::SKKCompleterQueryString() {
    NSString *string = [impl_ completerQueryString];
    return std::string([string UTF8String]);
}

void SKKInputEngine::SKKCompleterUpdate(const std::string &entry) {
    [impl_ completerUpdateWithEntry:[NSString stringWithUTF8String:entry.c_str()]];
}

const SKKEntry SKKInputEngine::SKKSelectorQueryEntry() {
    auto array = [impl_ bridgeSelectorQueryEntry];
    return SKKEntry(std::string(array[0].UTF8String), std::string(array[1].UTF8String));
}

void SKKInputEngine::SKKSelectorUpdate(const SKKCandidate &candidate) {
    [impl_ bridgeSelectorUpdateWithCandidate:[NSString stringWithUTF8String:candidate.ToString().c_str()]];
}

void SKKInputEngine::SKKOkuriListenerAppendEntry(const std::string &fixed) {
    [impl_ okkuriListenerAppendEntryWithFixed:[NSString stringWithUTF8String:fixed.c_str()]];
}

id<SKKCompleterBuddyProtcol> SKKInputEngine::getCompleterBuddyProtocol() {
    return impl_;
}

id<SKKSelectorBuddyProtocol> SKKInputEngine::getSelectorBuddyProtocol() {
    return impl_;
}

id<SKKOkuriListenerProtocol> SKKInputEngine::getOkuriListenerProtocol() {
    return impl_;
}

id<SKKInputQueueObserverProtocol> SKKInputEngine::getInputQueueObserverProtocol() {
    return impl_;
}

void retainSKKInputEngine(SKKInputEngine *obj) {
    obj->IntrusiveRefCounted<SKKInputEngine>::retain();
}

void releaseSKKInputEngine(SKKInputEngine *obj) {
    obj->IntrusiveRefCounted<SKKInputEngine>::release();
}
