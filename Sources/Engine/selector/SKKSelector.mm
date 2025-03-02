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

#import <AquaSKKEngine/SKKSelector.h>
#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKCandidateWindowBridge.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKSelector::SKKSelector(SKKSelectorBuddy *buddy, SKKCandidateWindow *window) {
    auto bridge = [[SKKCandidateWindowBridge alloc] initWithImpl:window];
    impl_ = new SwiftObject<AquaSKKEngine::SKKSelectorImpl>(buddy, bridge);
}

SKKSelector::~SKKSelector() {
    delete impl_;
}

bool SKKSelector::IsInline() const {
    return (*impl_)->isInline();
}

bool SKKSelector::Execute(int inlineCount) {
    return (*impl_)->execute(inlineCount);
}

bool SKKSelector::Next() {
    return (*impl_)->next();
}

bool SKKSelector::Prev() {
    return (*impl_)->prev();
}

void SKKSelector::CursorLeft() {
    (*impl_)->cursorLeft();
}

void SKKSelector::CursorRight() {
    (*impl_)->cursorRight();
}

void SKKSelector::CursorUp() {
    (*impl_)->cursorUp();
}

void SKKSelector::CursorDown() {
    (*impl_)->cursorDown();
}

bool SKKSelector::Select(char label) {
    return (*impl_)->select(label);
}

void SKKSelector::Show() {
    (*impl_)->show();
}

void SKKSelector::Hide() {
    (*impl_)->hide();
}
