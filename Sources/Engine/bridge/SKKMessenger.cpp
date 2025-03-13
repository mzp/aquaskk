//
//  SKKMessenger.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/13.
//

#include <AquaSKKEngine/SKKMessenger.h>

void retainSKKMessenger(SKKMessenger *obj) {
    obj->retain();
}
void releaseSKKMessenger(SKKMessenger *obj) {
    obj->release();
}

