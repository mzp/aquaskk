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

#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/SKKInputQueue.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKInputQueue::SKKInputQueue(SKKInputQueueObserver *observer)
    : impl_(new SwiftObject(AquaSKKEngine::SKKInputQueueImpl::init(observer))) {}

void SKKInputQueue::SelectInputMode(SKKInputMode mode) {
    (*impl_)->bridgedSelectInputMode((int32_t)mode);
}

void SKKInputQueue::AddChar(char code, bool direct) {
    (*impl_)->addChar(code, direct);
}

void SKKInputQueue::RemoveChar() {
    (*impl_)->removeChar();
}

void SKKInputQueue::Terminate() {
    (*impl_)->terminate();
}

void SKKInputQueue::Clear() {
    (*impl_)->clear();
}

bool SKKInputQueue::IsEmpty() const {
    return (*impl_)->isEmpty();
}

const std::string SKKInputQueue::QueueString() const {
    return (*impl_)->getQueryString();
}

bool SKKInputQueue::CanConvert(char code) const {
    return (*impl_)->canConvert(code);
}

void retainSKKInputQueueObserver(SKKInputQueueObserver *obj) {
    obj->retain();
}

void releaseSKKInputQueueObserver(SKKInputQueueObserver *obj) {
    obj->release();
}
