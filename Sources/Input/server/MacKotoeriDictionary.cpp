/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2002 phonohawk
  Copyright (C) 2005-2010 Tomotaka SUWA <tomotaka.suwa@gmail.com>

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
/*
    Directory Maneger対応　2002.09.25 Shin_ichi Abe.
*/

#include <iostream>
#include <vector>
#include <Carbon/Carbon.h>
#import <AquaSKKBackend/SKKCandidate.h>
#import <AquaSKKInput/MacKotoeriDictionary.h>

// Snow Leopard 以降では Dictionary Manager は非サポート
class KotoeriImpl {
public:
    void Initialize(const std::string &) {}
    void Find(const std::string &, SKKCandidateSuite &) {}
};

// ======================================================================
// ことえり辞書インタフェース
// ======================================================================
MacKotoeriDictionary::MacKotoeriDictionary()
    : impl_(new KotoeriImpl()) {}

MacKotoeriDictionary::~MacKotoeriDictionary() {
    // auto_ptr<KotoeriImpl> のデストラクタが実体化されるタイミングを遅
    // 延させるために、空のデストラクタ実装が必要
}

void MacKotoeriDictionary::Initialize(const std::string &location) {
    impl_->Initialize(location);
}

void MacKotoeriDictionary::Find(const SKKEntry &entry, SKKCandidateSuite &result) {
    if(!entry.IsOkuriAri()) {
        impl_->Find(entry.EntryString(), result);
    }
}
