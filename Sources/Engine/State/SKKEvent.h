/* -*- C++ -*-

   MacOS X implementation of the SKK input method.

   Copyright (C) 2007-2008 Tomotaka SUWA <t.suwa@mac.com>

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

#ifndef SKKEvent_h
#define SKKEvent_h

#include <sstream>
#import <swift/bridging>
#import <AquaSKKEngine/SKKEventID.h>

// SKK_CHAR 属性
enum {
    None,
    Direct = (1 << 0),
    UpperCases = (1 << 1),
    ToggleKana = (1 << 2),
    ToggleJisx0201Kana = (1 << 3),
    SwitchToAscii = (1 << 4),
    SwitchToJisx0208Latin = (1 << 5),
    EnterJapanese = (1 << 6),
    EnterAbbrev = (1 << 7),
    NextCompletion = (1 << 8),
    PrevCompletion = (1 << 9),
    NextCandidate = (1 << 10),
    PrevCandidate = (1 << 11),
    RemoveTrigger = (1 << 12),
    InputChars = (1 << 13),
    CompConversion = (1 << 14),
    StickyKey = (1 << 15)
};

// 処理オプション
enum {
    Default = 0,
    AlwaysHandled = 1 << 0, // 強制的に「処理済み」にする
    PseudoHandled = 1 << 1, // 処理は行うが「未処理」とする
    CapsLock = 1 << 2       // CapsLock
};

// イベントパラメータ
class SKKEvent {
public:
    int id;             // イベント(冗長だが仕方がない)
    unsigned char code; // 文字そのもの
    int attribute;      // SKK_CHAR 属性
    int option;         // 処理オプション

    SKKEvent();
    SKKEvent(int e, unsigned char c, int a = None);
    SKKEvent(int id, unsigned char code, int attribute, int option);

    // SKK_CHAR 属性問い合わせ
    bool IsDirect() const;
    bool IsUpperCases() const;
    bool IsToggleKana() const;
    bool IsToggleJisx0201Kana() const;
    bool IsSwitchToAscii() const;
    bool IsSwitchToJisx0208Latin() const;
    bool IsEnterJapanese() const;
    bool IsEnterAbbrev() const;
    bool IsNextCompletion() const;
    bool IsPrevCompletion() const;
    bool IsNextCandidate() const;
    bool IsPrevCandidate() const;
    bool IsRemoveTrigger() const;
    bool IsInputChars() const;
    bool IsCompConversion() const;
    bool IsStickyKey() const;
    const static SKKEvent &Null();
    bool operator==(const SKKEvent &rhs) const;
    std::string attr() const;
    std::string dump() const;
};

#endif
