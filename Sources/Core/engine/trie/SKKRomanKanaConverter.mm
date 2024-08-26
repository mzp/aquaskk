/* -*- C++ -*-

  MacOS X implementation of the SKK input method.

  Copyright (C) 2007 Tomotaka SUWA <t.suwa@mac.com>

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

#include "SKKRomanKanaConverter.h"
#import <AquaSKKCore/AISRomanKanaConverter.h>

SKKRomanKanaConverter::SKKRomanKanaConverter()
    : impl(NULL) {}

SKKRomanKanaConverter::SKKRomanKanaConverter(const SKKRomanKanaConverter &romanKana)
    : impl(romanKana.impl) {}

SKKRomanKanaConverter &SKKRomanKanaConverter::theInstance() {
    static SKKRomanKanaConverter obj;
    return obj;
}

void SKKRomanKanaConverter::Initialize(const std::string &path) {
    NSString *nsPath = [NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding];
    AICRomanKanaConverter *impl = [[AICRomanKanaConverter alloc] initWithPath:nsPath error:nil];

    AICRomanKanaConverter *oldImpl = (AICRomanKanaConverter *)impl;
    this->impl = (void *)[impl retain];
    if(oldImpl != NULL) {
        [oldImpl release];
    }
}

void SKKRomanKanaConverter::Patch(const std::string &path) {
    NSString *nsPath = [NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding];
    AICRomanKanaConverter *impl = (AICRomanKanaConverter *)this->impl;
    [impl appendPath:nsPath error:nil];
}

bool SKKRomanKanaConverter::Convert(SKKInputMode mode, const std::string &str, SKKRomanKanaConversionResult &result) {
    NSString *nsstring = [NSString stringWithCString:str.c_str() encoding:NSUTF8StringEncoding];
    AICRomanKanaConverter *impl = (AICRomanKanaConverter *)this->impl;
    AICRomanKanaResult *ret = [impl convert:nsstring inputMode:mode];
    result.output = std::string([ret.output UTF8String]);
    result.next = std::string([ret.next UTF8String]);
    result.intermediate = std::string([ret.intermediate UTF8String]);
    return (bool)ret.converted;
}
