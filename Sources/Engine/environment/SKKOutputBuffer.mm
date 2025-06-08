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
#import "SKKOutputBuffer.h"
#import <AquaSKKBackend/AquaSKKBackend.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKOutputBuffer::SKKOutputBuffer(id<SKKFrontEndProtocol> frontend)
    : impl_([[SKKOutputBufferImpl alloc] initWithFrontend:frontend]) {}

void SKKOutputBuffer::Fix(const std::string &str) {
    [impl_ fixWithString:SKKUTF8String(str)];
}

void SKKOutputBuffer::Compose(const std::string &str, int cursor) {
    [impl_ composeWithString:SKKUTF8String(str) cursor:cursor];
}

void SKKOutputBuffer::Convert(const std::string &str) {
    [impl_ convertWithString:SKKUTF8String(str)];
}

void SKKOutputBuffer::SetMark() {
    [impl_ setMark];
}

int SKKOutputBuffer::GetMark() const {
    return static_cast<int>([impl_ getMark]);
}

void SKKOutputBuffer::Clear() {
    [impl_ clear];
}

void SKKOutputBuffer::Output() {
    [impl_ output];
}

bool SKKOutputBuffer::IsComposing() const {
    return [impl_ isComposing];
}
