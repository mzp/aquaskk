/*

  MacOS X implementation of the SKK input method.

  Copyright (C) 2010 Tomotaka SUWA <tomotaka.suwa@gmail.com>

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

#import <AquaSKKBackend/SKKCandidateSuite.h>
#import <AquaSKKBackend/SKKDistributedUserDictionary.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>
#include "stringutil.h"
#include "utf8util.h"



void SKKDistributedUserDictionary::Initialize(const std::string &path) {
    (*impl_)->initialize(path);
}

void SKKDistributedUserDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}

std::string SKKDistributedUserDictionary::ReverseLookup(const std::string &candidate) {
    // 今のところサポートしない
    return "";
}

void SKKDistributedUserDictionary::Complete(SKKCompletionHelper &helper) {
    (*impl_)->complete(helper);
}

void SKKDistributedUserDictionary::Register(const SKKEntry &entry, const SKKCandidate &candidate) {
    (*impl_)->register_(entry, candidate);
}

void SKKDistributedUserDictionary::Remove(const SKKEntry &entry, const SKKCandidate &candidate) {
    (*impl_)->remove(entry, candidate);
}

void SKKDistributedUserDictionary::SetPrivateMode(bool flag) {
    // FIXME: to be done
}

SKKDistributedUserDictionary::SKKDistributedUserDictionary()
: impl_(new SwiftObject<AquaSKKBackend::SKKDistributedUserDictionary>()) {}

SKKDistributedUserDictionary::~SKKDistributedUserDictionary() {
    delete impl_;
}
