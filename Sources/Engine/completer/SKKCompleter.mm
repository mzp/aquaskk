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

#import <AquaSKKBackend/SwiftObject.h>
#import <AquaSKKEngine/SKKCompleter.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

struct SKKCompleterContainer {
    SwiftObject<AquaSKKEngine::SKKCompleterImpl> *impl_;

    SKKCompleterContainer(SKKCompleterBuddy *buddy)
        : impl_(new SwiftObject(AquaSKKEngine::SKKCompleterImpl::init(buddy))) {}
};

SKKCompleter::SKKCompleter(SKKCompleterBuddy *buddy)
    : container_(new SKKCompleterContainer(buddy)) {}

bool SKKCompleter::Execute(int limit) {
    return (*(container_->impl_))->execute(limit);
}

bool SKKCompleter::Remove() {
    return (*(container_->impl_))->remove();
}

void SKKCompleter::Next() {
    return (*(container_->impl_))->next();
}

void SKKCompleter::Prev() {
    return (*(container_->impl_))->prev();
}

AquaSKKEngine::SKKCompleterImpl *SKKCompleter::getImpl() {
    return container_->impl_->getPointer();
}

void retainSKKCompleter(SKKCompleter *obj) {
    obj->retain();
}

void releaseSKKCompleter(SKKCompleter *obj) {
    obj->release();
}
