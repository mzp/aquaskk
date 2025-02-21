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

#ifndef SKKCommonDictionary_h
#define SKKCommonDictionary_h

#import <AquaSKKBackend/SKKBaseDictionary.h>
#import <AquaSKKBackend/SwiftObject.h>

namespace AquaSKKBackend {
    class SKKCommonDictionaryEUCJP;
    class SKKCommonDictionaryUTF8;
} // namespace AquaSKKBackend

// SKK 共有辞書(EUC-JP 版)
class SKKCommonDictionary : public SKKBaseDictionary {
    SwiftObject<AquaSKKBackend::SKKCommonDictionaryEUCJP> *impl_;

public:
    SKKCommonDictionary();
    virtual ~SKKCommonDictionary();
    virtual void Initialize(const std::string &path);
    virtual void Find(const SKKEntry &entry, SKKCandidateSuite &result);
    virtual std::string ReverseLookup(const std::string &candidate);
    virtual void Complete(SKKCompletionHelper &helper);
};

// SKK 共有辞書(UTF-8 版)
class SKKCommonDictionaryUTF8 : public SKKBaseDictionary {
    SwiftObject<AquaSKKBackend::SKKCommonDictionaryUTF8> *impl_;

public:
    SKKCommonDictionaryUTF8();
    virtual ~SKKCommonDictionaryUTF8();
    virtual void Initialize(const std::string &path);
    virtual void Find(const SKKEntry &entry, SKKCandidateSuite &result);
    virtual std::string ReverseLookup(const std::string &candidate);
    virtual void Complete(SKKCompletionHelper &helper);
};

#endif
