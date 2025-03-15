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

// ======================================================================
// level 1：構築
// ======================================================================
State SKKState::Composing(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->composingState))->dispatch(event);
    return bridgePerform(action, &SKKState::TopState);
}

// ======================================================================
// level 2：見出し語編集
// ======================================================================
State SKKState::Edit(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->editState))->dispatch(event);
    return bridgePerform(action, &SKKState::Composing);
}

// ======================================================================
// level 3 (sub of Edit)：見出し語入力
// ======================================================================
State SKKState::EntryInput(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->entryInputState))->dispatch(event);
    return bridgePerform(action, &SKKState::Edit);
}

// ======================================================================
// level 4 (sub of EntryInput)：日本語
// ======================================================================
State SKKState::KanaEntry(const Event &event) {

    SKKStateMachineAction action = (*(this->container_->kanaEntryState))->dispatch(event);
    return bridgePerform(action, &SKKState::EntryInput);
}

// ======================================================================
// level 4 (sub of EntryInput)：省略表記
// ======================================================================
State SKKState::AsciiEntry(const Event &event) {

    SKKStateMachineAction action = (*(this->container_->asciiEntryState))->dispatch(event);
    return bridgePerform(action, &SKKState::EntryInput);
}

// ======================================================================
// level 3 (sub of Edit)：見出し語補完
// ======================================================================
State SKKState::EntryCompletion(const Event &event) {

    SKKStateMachineAction action = (*(this->container_->entryCompletionState))->dispatch(event);
    return bridgePerform(action, &SKKState::Edit);
}

// ======================================================================
// level 2：候補選択
// ======================================================================
State SKKState::SelectCandidate(const Event &event) {

    SKKStateMachineAction action = (*(this->container_->selectCandidateState))->dispatch(event);
    return bridgePerform(action, &SKKState::Composing);
}

// ======================================================================
// level 1：送り
// ======================================================================
State SKKState::OkuriInput(const Event &event) {

    SKKStateMachineAction action = (*(this->container_->okuriInputState))->dispatch(event);
    return bridgePerform(action, &SKKState::TopState);
}
