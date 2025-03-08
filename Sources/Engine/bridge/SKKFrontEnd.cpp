//
//  SKKFrontEnd.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/07.
//

#include <AquaSKKEngine/SKKFrontEnd.h>

void retainSKKFrontEnd(SKKFrontEnd *obj) {
    obj->retain();
}

void releaseSKKFrontEnd(SKKFrontEnd *obj) {
    obj->release();
}
