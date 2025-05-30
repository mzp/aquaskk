//
//  SKKSelectorBuddy.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/02.
//

#include "SKKSelectorBuddy.h"

void retainSKKSelectorBuddy(SKKSelectorBuddy *_Nonnull obj) {
    obj->retain();
}

void releaseSKKSelectorBuddy(SKKSelectorBuddy *_Nonnull obj) {
    obj->release();
}
