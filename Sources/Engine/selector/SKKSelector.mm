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

#import <AquaSKKEngine/SKKCandidateWindow.h>
#import <AquaSKKEngine/SKKCandidateWindowBridge.h>
#import <AquaSKKEngine/SKKSelector.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

struct SKKSelectorContainer {
private:
    SKKSelectorContainer();

public:
    SwiftObject<AquaSKKEngine::SKKSelectorImpl> *impl_;

    SKKSelectorContainer(SKKSelectorBuddy *buddy, SKKCandidateWindowBridge *bridge)
        : impl_(new SwiftObject(
              AquaSKKEngine::SKKSelectorImpl::createBridge(buddy, bridge))) {}

    ~SKKSelectorContainer() {
        //       delete impl_;
    }
};

SKKSelector::SKKSelector(SKKSelectorBuddy *buddy, SKKCandidateWindow *window) {
    bridge_ = new SKKCandidateWindowBridge(window);
    container_ = new SKKSelectorContainer(buddy, bridge_);
}
SKKSelector::SKKSelector(SKKSelector &selector)
    : bridge_(selector.bridge_), container_(selector.container_) {}

SKKSelector::~SKKSelector() {
    delete container_;
    releaseSKKCandidateWindowBridge(bridge_);
}

bool SKKSelector::IsInline() const {
    return (*(container_->impl_))->isInline();
}

bool SKKSelector::Execute(int inlineCount) {
    auto impl = container_->impl_;
    return (*impl)->execute(inlineCount);
}

bool SKKSelector::Next() {
    return (*(container_->impl_))->next();
}

bool SKKSelector::Prev() {
    return (*(container_->impl_))->prev();
}

void SKKSelector::CursorLeft() {
    (*(container_->impl_))->cursorLeft();
}

void SKKSelector::CursorRight() {
    (*(container_->impl_))->cursorRight();
}

void SKKSelector::CursorUp() {
    (*(container_->impl_))->cursorUp();
}

void SKKSelector::CursorDown() {
    (*(container_->impl_))->cursorDown();
}

bool SKKSelector::Select(char label) {
    return (*(container_->impl_))->select(label);
}

void SKKSelector::Show() {
    (*(container_->impl_))->show();
}

void SKKSelector::Hide() {
    (*(container_->impl_))->hide();
}

void retainSKKSelector(SKKSelector *obj) {
    obj->retain();
}
void releaseSKKSelector(SKKSelector *obj) {
    obj->release();
}
