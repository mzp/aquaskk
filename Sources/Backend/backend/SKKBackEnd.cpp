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

SKKBackEnd::SKKBackEnd() {}

SKKBackEnd &SKKBackEnd::theInstance() {
    static SKKBackEnd obj;
    return obj;
}

void SKKBackEnd::Initialize(const std::string &userdict_path, const SKKDictionaryKeyContainer &keys) {
    AquaSKKBackend::createBackendImpl().initialize(userdict_path, keys);
}

bool SKKBackEnd::Complete(const std::string &key, std::vector<std::string> &result, unsigned limit) {
    result = AquaSKKBackend::createBackendImpl().complete_(key, limit);
    return result.size() > 0;
}

bool SKKBackEnd::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    result.Clear();
    AquaSKKBackend::createBackendImpl().find(entry, result);
    return !result.IsEmpty();
}

std::string SKKBackEnd::ReverseLookup(const std::string &candidate) {
    return AquaSKKBackend::createBackendImpl().reverseLookup(candidate);
}

void SKKBackEnd::Register(const SKKEntry &entry, const SKKCandidate &candidate) {
    AquaSKKBackend::createBackendImpl().register_(entry, candidate);
}

void SKKBackEnd::Remove(const SKKEntry &entry, const SKKCandidate &candidate) {
    AquaSKKBackend::createBackendImpl().remove(entry, candidate);
}

void SKKBackEnd::UseNumericConversion(bool flag) {
    AquaSKKBackend::createBackendImpl().setNumericConversionEnabled(flag);
}

void SKKBackEnd::EnableExtendedCompletion(bool flag) {
    AquaSKKBackend::createBackendImpl().setExtendedCompletionEnabled(flag);
}

void SKKBackEnd::EnablePrivateMode(bool flag) {
    AquaSKKBackend::createBackendImpl().setPrivateModeEnabled(flag);
}

void SKKBackEnd::SetMinimumCompletionLength(int length) {
    AquaSKKBackend::createBackendImpl().setMinimumCompletionLength(length);
}
