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

#import "SKKTextBuffer.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#include "utf8util.h"

SKKTextBuffer::SKKTextBuffer()
    : impl_(new SwiftObject(AquaSKKEngine::SKKTextBufferImpl::init())) {}

SKKTextBuffer::~SKKTextBuffer() {
    delete impl_;
}

void SKKTextBuffer::Insert(const std::string &str) {
    (*impl_)->insert(str);
}

void SKKTextBuffer::BackSpace() {
    (*impl_)->backSpace();
}

void SKKTextBuffer::Delete() {
    (*impl_)->delete_();
}

void SKKTextBuffer::Clear() {
    (*impl_)->clear();
}

void SKKTextBuffer::CursorLeft() {
    (*impl_)->cursorLeft();
}

void SKKTextBuffer::CursorRight() {
    (*impl_)->cursorRight();
}

void SKKTextBuffer::CursorUp() {
    (*impl_)->cursorUp();
}

void SKKTextBuffer::CursorDown() {
    (*impl_)->cursorDown();
}

int SKKTextBuffer::CursorPosition() const {
    return static_cast<int>((*impl_)->getCursorPosition());
}

bool SKKTextBuffer::IsEmpty() const {
    return (*impl_)->isEmpty();
}

bool SKKTextBuffer::operator==(const std::string &str) const {
    return std::string((*impl_)->getString()) == str;
}

std::string SKKTextBuffer::String() const {
    return std::string((*impl_)->getString());
}

std::string SKKTextBuffer::LeftString() const {
    return std::string((*impl_)->getLeftString());
}

std::string SKKTextBuffer::RightString() const {
    return std::string((*impl_)->getRightString());
}
