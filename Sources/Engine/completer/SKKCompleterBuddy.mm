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

void retainSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->retain();
}

void releaseSKKCompleterBuddy(SKKCompleterBuddy *obj) {
    obj->release();
}
