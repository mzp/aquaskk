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
// level 1：直接入力
// ======================================================================
State SKKState::Primary(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->primaryState))->dispatch(event);
    return bridgePerform(action, &SKKState::TopState);
}

// ======================================================================
// level 2 (sub of Primary)：かな入力
// ======================================================================
State SKKState::KanaInput(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->kanaInputState))->dispatch(event);
    return bridgePerform(action, &SKKState::Primary);
}

// ======================================================================
// level 3 (sub of KanaInput)：ひらかな
// ======================================================================
State SKKState::Hirakana(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->hirakanaState))->dispatch(event);
    return bridgePerform(action, &SKKState::KanaInput);
}

// ======================================================================
// level 3 (sub of KanaInput)：カタカナ
// ======================================================================
State SKKState::Katakana(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->katakanaState))->dispatch(event);
    return bridgePerform(action, &SKKState::KanaInput);
}

// ======================================================================
// level 3 (sub of KanaInput)：半角カタカナ
// ======================================================================
State SKKState::Jisx0201Kana(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->jisx0201kana))->dispatch(event);
    return bridgePerform(action, &SKKState::KanaInput);
}

// ======================================================================
// level 2 (sub of Primary)：Latin 入力
// ======================================================================
State SKKState::LatinInput(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->latinInputState))->dispatch(event);
    return bridgePerform(action, &SKKState::Primary);
}

// ======================================================================
// level 2 (sub of LatinInput)：ASCII
// ======================================================================
State SKKState::Ascii(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->asciiState))->dispatch(event);
    return bridgePerform(action, &SKKState::LatinInput);
}

// ======================================================================
// level 2 (sub of LatinInput)：全角英数
// ======================================================================
State SKKState::Jisx0208Latin(const Event &event) {
    SKKStateMachineAction action = (*(this->container_->jis0208LatinState))->dispatch(event);
    return bridgePerform(action, &SKKState::LatinInput);
}
