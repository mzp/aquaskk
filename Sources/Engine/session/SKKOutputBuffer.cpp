/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2009 Tomotaka SUWA <t.suwa@mac.com>

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

#import <AquaSKKEngine/SKKOutputBuffer.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#include "SKKFrontEnd.h"

struct SKKOutputBufferContainer {
    SwiftObject<AquaSKKEngine::SKKOutputBufferImpl> *impl_;

    SKKOutputBufferContainer(SKKFrontEnd *frontend)
        : impl_(new SwiftObject(AquaSKKEngine::SKKOutputBufferImpl::init(frontend))) {}
};

SKKOutputBuffer::SKKOutputBuffer(SKKFrontEnd *frontend)
    : container_(new SKKOutputBufferContainer(frontend)) {}

void SKKOutputBuffer::Fix(const std::string &str) {
    (*(container_->impl_))->fix(str);
}

void SKKOutputBuffer::Compose(const std::string &str, int cursor) {
    (*(container_->impl_))->compose(str, cursor);
}

void SKKOutputBuffer::Convert(const std::string &str) {
    (*(container_->impl_))->convert(str);
}

void SKKOutputBuffer::SetMark() {
    (*(container_->impl_))->setMark();
}

int SKKOutputBuffer::GetMark() const {
    return static_cast<int>((*(container_->impl_))->getMark());
}

void SKKOutputBuffer::Clear() {
    (*(container_->impl_))->clear();
}

void SKKOutputBuffer::Output() {
    (*(container_->impl_))->output();
}

bool SKKOutputBuffer::IsComposing() const {
    return (*(container_->impl_))->isComposing();
}
