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

#import "SKKUndoContext.h"
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

SKKUndoContext::SKKUndoContext(id<SKKFrontEndProtocol> frontend)
    : frontend_(frontend), impl_([[SKKUndoContextImpl alloc] initWithFrontend:frontend]) {}

SKKUndoResult SKKUndoContext::Undo() {
    return [impl_ undo];
}

bool SKKUndoContext::IsActive() const {
    return [impl_ isActive];
}

void SKKUndoContext::Clear() {
    [impl_ clear];
}

const std::string SKKUndoContext::Entry() const {
    return std::string(impl_.entry.UTF8String);
}

const std::string SKKUndoContext::Candidate() const {
    return std::string(impl_.candidate.UTF8String);
}

const std::string SKKUndoContext::getEntry() const {
    return std::string(impl_.entry.UTF8String);
}

const std::string SKKUndoContext::getCandidate() const {
    return std::string(impl_.entry.UTF8String);
}
