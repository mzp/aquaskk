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

#ifndef SKKGadgetDictionary_h
#define SKKGadgetDictionary_h

#import <AquaSKKBackend/SKKBaseDictionary.h>
#import <AquaSKKBackend/SwiftObject.h>
namespace AquaSKKBackend {
    class SKKGadgetDictionaryImpl;
}

// ======================================================================
// プログラム実行変換辞書クラス
// ======================================================================
class SKKGadgetDictionary : public SKKBaseDictionary {
    SwiftObject<AquaSKKBackend::SKKGadgetDictionaryImpl> *impl_;

public:
    SKKGadgetDictionary();
    ~SKKGadgetDictionary();

    virtual void Initialize(const std::string &location);

    virtual void Find(const SKKEntry &entry, SKKCandidateSuite &result);

    virtual void Complete(SKKCompletionHelper &helper);
};

#endif
