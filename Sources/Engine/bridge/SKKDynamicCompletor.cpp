//
//  SKKDynamicCompletor.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

#include <AquaSKKEngine/SKKDynamicCompletor.h>

void retainSKKDynamicCompletor(SKKDynamicCompletor *obj) {
    obj->retain();
}
void releaseSKKDynamicCompletor(SKKDynamicCompletor *obj) {
    obj->release();
}
