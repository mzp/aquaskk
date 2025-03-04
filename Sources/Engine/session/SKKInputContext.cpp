//
//  SKKInputContext.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/04.
//

#include "SKKInputContext.h"

void retainSKKInputContext(SKKInputContext *obj) {
    obj->retain();
}

void releaseSKKInputContext(SKKInputContext *obj) {
    obj->release();
}
