//
//  SKKAnnotator.cpp
//  AquaSKKEngine
//
//  Created by mzp on 2025/03/10.
//

#include <AquaSKKEngine/SKKAnnotator.h>

void retainSKKAnnotator(SKKAnnotator *obj) {
    obj->retain();
}
void releaseSKKAnnotator(SKKAnnotator *obj) {
    obj->release();
}
