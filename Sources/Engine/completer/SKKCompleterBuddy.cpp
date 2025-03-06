//
//  SKKCompleterBuddy.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/06.
//

#include "SKKCompleterBuddy.h"


std::string SKKCompleterBuddy::InvokeSKKCompleterQueryString(SKKCompleterBuddy *obj) {
    return obj->SKKCompleterQueryString();
}

void SKKCompleterBuddy::InvokeSKKCompleterUpdate(SKKCompleterBuddy *obj, std::string entry) {
    return obj->SKKCompleterUpdate(entry);
}

void retainSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->retain();
}

void releaseSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->release();
}
