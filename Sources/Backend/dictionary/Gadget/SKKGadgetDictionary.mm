/*

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

#import <AquaSKKBackend/SKKGadgetDictionary.h>
#import <AquaSKKBackend/AquaSKKBackend-Swift.h>

SKKGadgetDictionary::SKKGadgetDictionary()
    : impl_(new SwiftObject<AquaSKKBackend::SKKGadgetDictionaryImpl>()) {}

SKKGadgetDictionary::~SKKGadgetDictionary() {
    delete impl_;
}

void SKKGadgetDictionary::Initialize(const std::string &location) {
    (*impl_)->initialize(location);
}

void SKKGadgetDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    (*impl_)->find(entry, result);
}

void SKKGadgetDictionary::Complete(SKKCompletionHelper &helper) {
    auto bridge = SKKCompletionHelperBridge(&helper);
    (*impl_)->complete(bridge);
}
