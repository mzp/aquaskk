//
//  SKKCompleterBuddy.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

#include "SKKCompleterBuddy.h"
#import <Foundation/Foundation.h>
#import <AquaSKKEngine/AquaSKKEngine-Preamble.h>
#import <AquaSKKEngine/AquaSKKEngine-Swift.h>

std::string SKKCompleterBuddy::InvokeSKKCompleterQueryString(SKKCompleterBuddy *obj) {
    NSString *string = [obj->getProtocol() completerQueryString];
    return std::string(string.UTF8String);
}

void SKKCompleterBuddy::InvokeSKKCompleterUpdate(SKKCompleterBuddy *obj, std::string entry) {
    NSString *string = [NSString stringWithUTF8String:entry.c_str()];
    [obj->getProtocol() completerUpdateWithEntry:string];
}

void retainSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->retain();
}

void releaseSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->release();
}
