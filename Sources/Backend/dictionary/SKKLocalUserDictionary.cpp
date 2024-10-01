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

#import <AquaSKKBackend/SKKLocalUserDictionary.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKLocalUserDictionary::SKKLocalUserDictionary()
    : impl_(new SwiftObject<AquaSKKBackend::LocalUserDictionary>()) {}

SKKLocalUserDictionary::~SKKLocalUserDictionary() {
    delete impl_;
}

void SKKLocalUserDictionary::Initialize(const std::string &path) {
    (*impl_)->initialize(path);
}

void SKKLocalUserDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}

std::string SKKLocalUserDictionary::ReverseLookup(const std::string &candidate) {
    return (*impl_)->reverseLookup(candidate);
}

void SKKLocalUserDictionary::Complete(SKKCompletionHelper &helper) {
    auto bridge = SKKCompletionHelperBridge(&helper);
    (*impl_)->complete(bridge);
}

void SKKLocalUserDictionary::Register(const SKKEntry &entry, const SKKCandidate &candidate) {
    (*impl_)->register_(entry, candidate);
}

void SKKLocalUserDictionary::Remove(const SKKEntry &entry, const SKKCandidate &candidate) {
    return (*impl_)->remove(entry, candidate);
}

void SKKLocalUserDictionary::SetPrivateMode(bool flag) {
    (*impl_)->setPrivateMode(flag);
}
