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
    const SKKEvent &param = event.Param();

    switch(event) {
    case ENTRY_EVENT:
        editor_->SelectInputMode(SKKInputMode::HirakanaInputMode);
        return 0;

    case SKK_HIRAKANA_MODE:
        return 0;

    case SKK_CHAR:
        if(!(param.IsInputChars() && editor_->CanConvert(param.code))) {
            // 変換する文字がない場合のみ、ToggleKana等の処理する
            //
            // 例: AZIKの場合
            //
            //   - [: ToggeKana
            //   - x[: 鍵括弧
            //
            // が割り当てられている
            if(param.IsToggleKana()) {
                return State::Transition(&SKKState::Katakana);
            }

            if(param.IsToggleJisx0201Kana()) {
                return State::Transition(&SKKState::Jisx0201Kana);
            }
        }
    }

    return &SKKState::KanaInput;
}

// ======================================================================
// level 3 (sub of KanaInput)：カタカナ
// ======================================================================
State SKKState::Katakana(const Event &event) {
    const SKKEvent &param = event.Param();

    switch(event) {
    case ENTRY_EVENT:
        editor_->SelectInputMode(SKKInputMode::KatakanaInputMode);
        return 0;

    case SKK_KATAKANA_MODE:
        return 0;

    default:
        if(!(event == SKK_CHAR && param.IsInputChars() && editor_->CanConvert(param.code))) {
            // 変換する文字がない場合のみ、ToggleKana等の処理する
            if(event == SKK_JMODE || param.IsToggleKana()) {
                return State::Transition(&SKKState::Hirakana);
            }

            if(param.IsToggleJisx0201Kana()) {
                return State::Transition(&SKKState::Jisx0201Kana);
            }
        }
    }

    return &SKKState::KanaInput;
}

// ======================================================================
// level 3 (sub of KanaInput)：半角カタカナ
// ======================================================================
State SKKState::Jisx0201Kana(const Event &event) {
    const SKKEvent &param = event.Param();

    switch(event) {
    case ENTRY_EVENT:
        editor_->SelectInputMode(SKKInputMode::Jisx0201KanaInputMode);
        return 0;

    case SKK_JISX0201KANA_MODE:
        return 0;

    default:
        if(!(event == SKK_CHAR && param.IsInputChars() && editor_->CanConvert(param.code))) {
            // 変換する文字がない場合のみ、ToggleKana等の処理する
            if(event == SKK_JMODE || param.IsToggleKana() || param.IsToggleJisx0201Kana()) {
                return State::Transition(&SKKState::Hirakana);
            }
        }
    }

    return &SKKState::KanaInput;
}

// ======================================================================
// level 2 (sub of Primary)：Latin 入力
// ======================================================================
State SKKState::LatinInput(const Event &event) {
    SKKEvent param(event.Param());

    switch(event) {
    case SKK_JMODE:
        return State::Transition(&SKKState::Hirakana);

    case SKK_CHAR:
        if(param.IsInputChars()) {
            if(param.option & CapsLock) {
                param.code = std::toupper(param.code);
            }
            editor_->HandleChar(param.code, param.IsDirect());
            return 0;
        }
    }

    return &SKKState::Primary;
}

// ======================================================================
// level 2 (sub of LatinInput)：ASCII
// ======================================================================
State SKKState::Ascii(const Event &event) {
    switch(event) {
    case ENTRY_EVENT:
        editor_->SelectInputMode(SKKInputMode::AsciiInputMode);
        return 0;

    case SKK_ASCII_MODE:
        return 0;
    }

    return &SKKState::LatinInput;
}

// ======================================================================
// level 2 (sub of LatinInput)：全角英数
// ======================================================================
State SKKState::Jisx0208Latin(const Event &event) {
    const SKKEvent &param = event.Param();

    switch(event) {
    case ENTRY_EVENT:
        editor_->SelectInputMode(SKKInputMode::Jisx0208LatinInputMode);
        return 0;

    case SKK_JISX0208LATIN_MODE:
        return 0;

    default:
        if(event == SKK_ASCII_MODE || (!param.IsInputChars() && param.IsSwitchToAscii())) {
            return State::Transition(&SKKState::Ascii);
        }
    }

    return &SKKState::LatinInput;
}
