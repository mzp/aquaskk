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

#import <AquaSKKBackend/SwiftObject.h>
#import <AquaSKKEngine/SKKUndoContext.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>
#include "SKKFrontEnd.h"

struct SKKUndoContextContainer {
    SwiftObject<AquaSKKEngine::SKKUndoContextImpl> *impl_;
    SKKUndoContextContainer(SKKFrontEnd *frontend)
        : impl_(new SwiftObject(AquaSKKEngine::SKKUndoContextImpl::init(frontend))) {
        {
        }
    }
};

SKKUndoContext::SKKUndoContext(SKKFrontEnd *frontend)
    : container_(new SKKUndoContextContainer(frontend)) {}

SKKUndoResult SKKUndoContext::Undo() {
    int result = (*(container_->impl_))->bridgedUndo();
    return SKKUndoResult(result);
}

bool SKKUndoContext::IsActive() const {
    return (*(container_->impl_))->isActive();
}

void SKKUndoContext::Clear() {
    (*(container_->impl_))->clear();
}

const std::string SKKUndoContext::Entry() const {
    return (*(container_->impl_))->bridgeEntry();
}

const std::string SKKUndoContext::Candidate() const {
    return (*(container_->impl_))->bridgeCandidate();
}

const std::string SKKUndoContext::getEntry() const {
    return (*(container_->impl_))->bridgeEntry();
}

const std::string SKKUndoContext::getCandidate() const {
    return (*(container_->impl_))->bridgeCandidate();
}
