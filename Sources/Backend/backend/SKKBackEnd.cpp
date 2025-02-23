/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2008-2010 Tomotaka SUWA <tomotaka.suwa@gmail.com>

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

#import <AquaSKKBackend/SKKBackEnd.h>
#import <AquaSKKBackend/SKKCompletionHelper.h>
#import <AquaSKKBackend/SKKDictionaryKey.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKBackEnd::SKKBackEnd()
    : impl_(new SwiftObject<AquaSKKBackend::SKKBackend>()) {}

SKKBackEnd &SKKBackEnd::theInstance() {
    static SKKBackEnd obj;
    return obj;
}

void SKKBackEnd::Initialize(const std::string &userdict_path, const SKKDictionaryKeyContainer &keys) {
    (*impl_)->initialize(userdict_path, keys);
}

bool SKKBackEnd::Complete(const std::string &key, std::vector<std::string> &result, unsigned limit) {
    return (*impl_)->complete(key, limit, result);
}

bool SKKBackEnd::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    result.Clear();
    (*impl_)->find(entry, result);
    return !result.IsEmpty();
}

std::string SKKBackEnd::ReverseLookup(const std::string &candidate) {
    return (*impl_)->reverseLookup(candidate);
}

void SKKBackEnd::Register(const SKKEntry &entry, const SKKCandidate &candidate) {
    (*impl_)->register_(entry, candidate);
}

void SKKBackEnd::Remove(const SKKEntry &entry, const SKKCandidate &candidate) {
    (*impl_)->remove(entry, candidate);
}

void SKKBackEnd::UseNumericConversion(bool flag) {
    (*impl_)->setNumericConversionEnabled(flag);
}

void SKKBackEnd::EnableExtendedCompletion(bool flag) {
    (*impl_)->setExtendedCompletionEnabled(flag);
}

void SKKBackEnd::EnablePrivateMode(bool flag) {
    (*impl_)->setPrivateModeEnabled(flag);
}

void SKKBackEnd::SetMinimumCompletionLength(int length) {
    (*impl_)->setMinimumCompletionLength(length);
}
