/* -*- ObjC -*-

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

#import <AquaSKKBackend/SKKAutoUpdateDictionary.h>
#import <AquaSKKBackend/SKKCommonDictionary.h>
#import <AquaSKKBackend/SKKDictionaryFactory.h>
#import <AquaSKKBackend/SKKDistributedUserDictionary.h>
#import <AquaSKKBackend/SKKGadgetDictionary.h>
#import <AquaSKKBackend/SKKLocalUserDictionary.h>
#import <AquaSKKBackend/SKKProxyDictionary.h>
#import <AquaSKKInput/MacKotoeriDictionary.h>
#import <AquaSKKInput/SKKServer.h>

namespace {
    // 順番の入れ替えは禁止(追加のみ)
    struct DictionaryTypes {
        enum {
            Common,
            AutoUpdate,
            Proxy,
            Kotoeri,
            Gadget,
            CommonUTF8,
        };
    };
} // namespace

void SKKServerRegisterDictionaries() {
    SKKRegisterFactoryMethod<SKKCommonDictionary>(DictionaryTypes::Common);
    SKKRegisterFactoryMethod<SKKCommonDictionaryUTF8>(DictionaryTypes::CommonUTF8);
    SKKRegisterFactoryMethod<SKKAutoUpdateDictionary>(DictionaryTypes::AutoUpdate);
    SKKRegisterFactoryMethod<SKKProxyDictionary>(DictionaryTypes::Proxy);
    SKKRegisterFactoryMethod<MacKotoeriDictionary>(DictionaryTypes::Kotoeri);
    SKKRegisterFactoryMethod<SKKGadgetDictionary>(DictionaryTypes::Gadget);
}
